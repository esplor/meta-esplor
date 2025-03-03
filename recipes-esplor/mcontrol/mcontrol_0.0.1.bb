SUMMARY = "Control system via mqtt"
LICENSE = "CLOSED"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

#SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "mcontrol.service"

RDEPENDS:${PN} = "python3-core python3-paho-mqtt"
FILES:${PN} += "${systemd_system_unitdir}/mcontrol.service ${bindir}/mqtt-client.py"

SRC_URI = "file://mqtt-client.py file://mcontrol.service"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${systemd_system_unitdir}
    install -d ${D}${bindir}
    install -m 0644 ${S}/mcontrol.service ${D}${systemd_system_unitdir}
    install -m 0700 ${S}/mqtt-client.py ${D}${bindir}
}
