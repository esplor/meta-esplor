FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://99-wlan.network file://journald.conf file://wait-online-any.conf file://i2c-dev.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/99-wlan.network ${D}${sysconfdir}/systemd/network/

    install -d ${D}${sysconfdir}/systemd/
    install -m 0644 ${WORKDIR}/journald.conf ${D}${sysconfdir}/systemd/journald.conf

    # Only wait for any single interface to be online (don't block on unplugged eth0)
    install -d ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/
    install -m 0644 ${WORKDIR}/wait-online-any.conf ${D}${sysconfdir}/systemd/system/systemd-networkd-wait-online.service.d/wait-online-any.conf

    # Auto-load i2c-dev for DDC/CI monitor control
    install -d ${D}${sysconfdir}/modules-load.d/
    install -m 0644 ${WORKDIR}/i2c-dev.conf ${D}${sysconfdir}/modules-load.d/i2c-dev.conf
}
