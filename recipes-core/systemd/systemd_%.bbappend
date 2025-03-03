SUMMARY = "Integrate wpa credentials"
LICENSE = "MIT"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI = "file://99-wlan.network"

do_install_append() {
    install -d ${D}/etc/systemd/network/
    install -m 0644 ${WORKDIR}/99-wlan.network ${D}/etc/systemd/network/
}

