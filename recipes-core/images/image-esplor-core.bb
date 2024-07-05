SUMMARY = "A console-only image that fully supports the target device \
hardware."

IMAGE_FEATURES:append = " splash"
IMAGE_INSTALL:append = " python3-paho-mqtt"

LICENSE = "MIT"

inherit core-image
