#!/bin/sh
URL=$(tr ' ' '\n' < /proc/cmdline | grep '^COG_URL=' | head -n 1 | cut -d= -f2- | tr -d '"'"'")
mkdir -p /run/cog
echo "COG_URL=${URL}" > /run/cog/env
