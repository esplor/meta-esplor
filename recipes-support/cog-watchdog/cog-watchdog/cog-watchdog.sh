#!/bin/sh
# Watches the kernel log for the vc4 "Resetting GPU" reset-cascade and
# forces a reboot when it starts looping. The cascade means an atomic
# commit worker has parked on an orphaned dma-fence and cog is wedged in
# D-state, which systemctl cannot recover from.
#
# Single resets (isolated timeouts) DO recover on their own, so the
# threshold counts resets in a short window rather than lifetime.

set -eu

WINDOW="${COG_WATCHDOG_WINDOW:-60 seconds ago}"
THRESHOLD="${COG_WATCHDOG_THRESHOLD:-10}"

count=$(journalctl -k --since "$WINDOW" -q --no-pager 2>/dev/null \
        | grep -c 'Resetting GPU' || true)

if [ "$count" -ge "$THRESHOLD" ]; then
    logger -t cog-watchdog -p daemon.crit \
        "GPU reset cascade: $count 'Resetting GPU' in last ${WINDOW}; forcing reboot"
    sync
    echo b > /proc/sysrq-trigger
fi
