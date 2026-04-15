set_vconsole_keymap() {
    echo 'KEYMAP=no-latin1' > ${IMAGE_ROOTFS}/etc/vconsole.conf
}

create_data_mountpoint() {
    install -d ${IMAGE_ROOTFS}/data
}

# meta-raspberrypi installs a psplash-start drop-in requiring a legacy
# fb0 platform device that never exists under full KMS (vc4-kms-v3d),
# which blocks the splash at boot. Its bbappend runs after ours, so
# remove at image-assembly time instead.
remove_psplash_framebuf_dropin() {
    rm -f ${IMAGE_ROOTFS}${systemd_system_unitdir}/psplash-start.service.d/framebuf.conf
    rmdir --ignore-fail-on-non-empty ${IMAGE_ROOTFS}${systemd_system_unitdir}/psplash-start.service.d 2>/dev/null || true
}

ROOTFS_POSTPROCESS_COMMAND += "set_vconsole_keymap; create_data_mountpoint; remove_psplash_framebuf_dropin;"
