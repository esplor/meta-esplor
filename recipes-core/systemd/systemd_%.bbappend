FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://99-wlan.network file://journald.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/99-wlan.network ${D}${sysconfdir}/systemd/network/

    install -d ${D}${sysconfdir}/systemd/
    install -m 0644 ${WORKDIR}/journald.conf ${D}${sysconfdir}/systemd/journald.conf
}
