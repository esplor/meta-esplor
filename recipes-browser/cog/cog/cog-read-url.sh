#!/bin/sh
URL=$(tr ' ' '\n' < /proc/cmdline | grep '^COG_URL=' | head -n 1 | cut -d= -f2- | tr -d '"'"'")
PLATFORM_PARAMS=$(tr ' ' '\n' < /proc/cmdline | grep '^COG_PLATFORM_PARAMS=' | head -n 1 | cut -d= -f2- | tr -d '"'"'")
COG_BG=$(tr ' ' '\n' < /proc/cmdline | grep '^COG_BG=' | head -n 1 | cut -d= -f2- | tr -d '"'"'")
mkdir -p /run/cog
echo "COG_URL=${URL}" > /run/cog/env
echo "COG_PLATFORM_PARAMS=${PLATFORM_PARAMS:-renderer=gles}" >> /run/cog/env
echo "COG_BG=${COG_BG:-black}" >> /run/cog/env
