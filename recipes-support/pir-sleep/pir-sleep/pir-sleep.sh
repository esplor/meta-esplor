#!/bin/sh
# Monitor PIR sensor via libgpiod; blank/wake display via `display` helper.
# Configure via /etc/default/pir-sleep or kernel cmdline.

[ -f /etc/default/pir-sleep ] && . /etc/default/pir-sleep || true

: "${PIR_SLEEP_GPIOCHIP:=gpiochip0}"
: "${PIR_SLEEP_GPIO:=18}"
: "${PIR_SLEEP_TIMEOUT:=600}"
: "${PIR_SLEEP_MODE:=both}"         # cec | ddc | both
: "${PIR_SLEEP_CEC_DEVICE:=/dev/cec0}"
: "${PIR_SLEEP_DDC_BUS:=}"

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

export PIR_SLEEP_MODE PIR_SLEEP_CEC_DEVICE PIR_SLEEP_DDC_BUS

echo "pir-sleep: gpio=$PIR_SLEEP_GPIOCHIP/$PIR_SLEEP_GPIO timeout=${PIR_SLEEP_TIMEOUT}s mode=$PIR_SLEEP_MODE"
display_on=1

# gpiomon v2 prints an event line on rising edge, and exits 0 after either
# --idle-timeout firing or -n events. Detect which happened via stdout:
# non-empty = motion, empty = inactivity.
while true; do
    result=$(gpiomon -c "$PIR_SLEEP_GPIOCHIP" -e rising -n 1 \
                     --idle-timeout "${PIR_SLEEP_TIMEOUT}s" \
                     -F "%e" "$PIR_SLEEP_GPIO" 2>/dev/null)
    if [ -n "$result" ]; then
        if [ "$display_on" = "0" ]; then
            echo "wake: motion detected (mode=$PIR_SLEEP_MODE)"
            display on
            display_on=1
        fi
    else
        if [ "$display_on" = "1" ]; then
            echo "standby: no motion for ${PIR_SLEEP_TIMEOUT}s (mode=$PIR_SLEEP_MODE)"
            display standby
            display_on=0
        fi
    fi
done
