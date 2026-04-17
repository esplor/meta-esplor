FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Override meta-raspberrypi's SPLASH_IMAGES:rpi with a machine-specific one.
SPLASH_IMAGES:raspberrypi3-64 = "file://psplash-esplor.png;outsuffix=default"

# Note: meta-raspberrypi installs a psplash-start drop-in (framebuf.conf)
# that waits for a legacy fb0 platform device absent on full KMS. That
# bbappend's layer priority is higher than ours, so removing the file here
# is overwritten. It's stripped at image time via ROOTFS_POSTPROCESS_COMMAND
# in core-image-base.bbappend instead.
