# Remember to set PACKAGECONFIG:append:pn-systemd = " firstboot"

apply_esplor_firstboot() {
    install -d ${IMAGE_ROOTFS}/etc/credstore
    printf 'Europe/Oslo' | install -m 0400 /dev/stdin ${IMAGE_ROOTFS}/etc/credstore/firstboot.timezone
    printf 'no-latin1'   | install -m 0400 /dev/stdin ${IMAGE_ROOTFS}/etc/credstore/firstboot.keymap
}

ROOTFS_POSTPROCESS_COMMAND += "apply_esplor_firstboot;"
