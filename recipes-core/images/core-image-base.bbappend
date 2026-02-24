# Remember to set PACKAGECONFIG:append:pn-systemd = " firstboot"

apply_esplor_firstboot() {
    install -d ${IMAGE_ROOTFS}/etc/credstore
    printf 'Europe/Oslo' > ${IMAGE_ROOTFS}/etc/credstore/firstboot.timezone
    printf 'no'          > ${IMAGE_ROOTFS}/etc/credstore/firstboot.keymap
}

ROOTFS_POSTPROCESS_COMMAND += "apply_esplor_firstboot;"
