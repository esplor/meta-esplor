set_vconsole_keymap() {
    echo 'KEYMAP=no-latin1' > ${IMAGE_ROOTFS}/etc/vconsole.conf
}

ROOTFS_POSTPROCESS_COMMAND += "set_vconsole_keymap; create_data_mountpoint;"

create_data_mountpoint() {
    install -d ${IMAGE_ROOTFS}/data
}
