SUMMARY = "Image with x11"

IMAGE_FEATURES:append = " x11-base"
IMAGE_INSTALL:append = " xfce4-terminal xfce4-session xfdesktop"

#IMAGE_FSTYPES:append = " wic.vmdk"

SYSTEMD_DEFAULT_TARGET = "multi-user.target"

LICENSE = "MIT"

inherit core-image
