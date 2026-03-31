SUMMARY = "CEC display sleep based on PIR motion sensor"
DESCRIPTION = "Monitors a GPIO-connected PIR sensor and sends HDMI CEC \
standby/wake commands to blank the display after inactivity."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://cec-sleep.sh \
    file://cec-sleep.service \
"

RDEPENDS:${PN} = "v4l-utils"

inherit systemd

SYSTEMD_SERVICE:${PN} = "cec-sleep.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/cec-sleep.sh ${D}${libexecdir}/cec-sleep.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/cec-sleep.service ${D}${systemd_system_unitdir}/cec-sleep.service
}

FILES:${PN} = " \
    ${libexecdir}/cec-sleep.sh \
    ${systemd_system_unitdir}/cec-sleep.service \
"
