inherit systemd
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "paho-mqtt.service"

FILES:${PN} += "${systemd_unitdir}/system/paho-mqtt.service"
SRC_URI:append = " file://mqtt-client.py file://paho-mqtt.service"

do_install:append() {
    install -d ${D}/${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/paho-mqtt.service ${D}/${systemd_unitdir}/system
    install -d ${D}/scripts
    install -m 0700 ${WORKDIR}/mqtt-client.py ${D}/scripts/
}

FILES:${PN} += " /scripts/"
