#!/bin/sh
# Monitor PIR sensor via libgpiod; blank/wake display via HDMI CEC and/or DDC/CI.
# Configure via /etc/default/pir-sleep or kernel cmdline.

PIR_SLEEP_GPIOCHIP=gpiochip0
PIR_SLEEP_GPIO=12
PIR_SLEEP_TIMEOUT=600
PIR_SLEEP_MODE=both            # cec | ddc | both
PIR_SLEEP_CEC_DEVICE=/dev/cec0
PIR_SLEEP_DDC_BUS=

[ -f /etc/default/pir-sleep ] && . /etc/default/pir-sleep || true

for param in $(tr ' ' '\n' < /proc/cmdline); do
    case "$param" in
        PIR_SLEEP_GPIOCHIP=*)   PIR_SLEEP_GPIOCHIP="${param#*=}" ;;
        PIR_SLEEP_GPIO=*)       PIR_SLEEP_GPIO="${param#*=}" ;;
        PIR_SLEEP_TIMEOUT=*)    PIR_SLEEP_TIMEOUT="${param#*=}" ;;
        PIR_SLEEP_MODE=*)       PIR_SLEEP_MODE="${param#*=}" ;;
        PIR_SLEEP_CEC_DEVICE=*) PIR_SLEEP_CEC_DEVICE="${param#*=}" ;;
        PIR_SLEEP_DDC_BUS=*)    PIR_SLEEP_DDC_BUS="${param#*=}" ;;
    esac
done

DDC_ARGS=
[ -n "$PIR_SLEEP_DDC_BUS" ] && DDC_ARGS="--bus $PIR_SLEEP_DDC_BUS"

use_cec() { [ "$PIR_SLEEP_MODE" = "cec" ] || [ "$PIR_SLEEP_MODE" = "both" ]; }
use_ddc() { [ "$PIR_SLEEP_MODE" = "ddc" ] || [ "$PIR_SLEEP_MODE" = "both" ]; }

standby() {
    use_cec && cec-ctl -d "$PIR_SLEEP_CEC_DEVICE" --standby >/dev/null 2>&1
    use_ddc && ddcutil $DDC_ARGS setvcp 0xD6 4 >/dev/null 2>&1
}

wakeup() {
    use_cec && cec-ctl -d "$PIR_SLEEP_CEC_DEVICE" --image-view-on >/dev/null 2>&1
    use_ddc && ddcutil $DDC_ARGS setvcp 0xD6 1 >/dev/null 2>&1
}

display_on=1

while true; do
    if timeout "$PIR_SLEEP_TIMEOUT" gpiomon -r -n 1 -s "$PIR_SLEEP_GPIOCHIP" "$PIR_SLEEP_GPIO" >/dev/null 2>&1; then
        if [ "$display_on" = "0" ]; then
            wakeup
            display_on=1
        fi
    else
        if [ "$display_on" = "1" ]; then
            standby
            display_on=0
        fi
    fi
done
