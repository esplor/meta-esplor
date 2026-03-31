#!/bin/sh
# Monitor PIR sensor on GPIO and blank/wake monitor via HDMI CEC.
# Configure via /etc/default/cec-sleep or kernel cmdline.

CEC_SLEEP_GPIO=17
CEC_SLEEP_TIMEOUT=600
CEC_SLEEP_DEVICE=/dev/cec0

[ -f /etc/default/cec-sleep ] && . /etc/default/cec-sleep || true

# Override from kernel cmdline
for param in $(tr ' ' '\n' < /proc/cmdline); do
    case "$param" in
        CEC_SLEEP_GPIO=*) CEC_SLEEP_GPIO="${param#*=}" ;;
        CEC_SLEEP_TIMEOUT=*) CEC_SLEEP_TIMEOUT="${param#*=}" ;;
    esac
done

GPIO_PATH="/sys/class/gpio/gpio${CEC_SLEEP_GPIO}"

# Export GPIO if not already
if [ ! -d "$GPIO_PATH" ]; then
    echo "$CEC_SLEEP_GPIO" > /sys/class/gpio/export
    sleep 0.1
fi
echo "in" > "${GPIO_PATH}/direction"

standby() {
    cec-ctl -d "$CEC_SLEEP_DEVICE" --standby 2>/dev/null
}

wakeup() {
    cec-ctl -d "$CEC_SLEEP_DEVICE" --image-view-on 2>/dev/null
}

last_motion=$(date +%s)
display_on=1

while true; do
    pir=$(cat "${GPIO_PATH}/value")

    if [ "$pir" = "1" ]; then
        last_motion=$(date +%s)
        if [ "$display_on" = "0" ]; then
            wakeup
            display_on=1
        fi
    fi

    now=$(date +%s)
    idle=$((now - last_motion))

    if [ "$idle" -ge "$CEC_SLEEP_TIMEOUT" ] && [ "$display_on" = "1" ]; then
        standby
        display_on=0
    fi

    sleep 1
done
