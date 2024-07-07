SUMMARY = "A console-only image that fully supports the target device \
hardware."

IMAGE_FEATURES:append = " splash"
IMAGE_INSTALL:append = " python3-paho-mqtt"
IMAGE_FSTYPES:append = " wic.vmdk"
LICENSE = "MIT"

inherit core-image
