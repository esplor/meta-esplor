SUMMARY = "Display sleep via PIR motion sensor (libgpiod) and DDC/CI"
DESCRIPTION = "Monitors a GPIO-connected PIR sensor with libgpiod and sends \
DDC/CI power commands via ddcutil to blank the display after inactivity."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://pir-sleep.sh \
    file://pir-sleep.service \
    file://display \
"

RDEPENDS:${PN} = "libgpiod-tools ddcutil v4l-utils"

inherit systemd

SYSTEMD_SERVICE:${PN} = "pir-sleep.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/pir-sleep.sh ${D}${libexecdir}/pir-sleep.sh

    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/display ${D}${bindir}/display

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/pir-sleep.service ${D}${systemd_system_unitdir}/pir-sleep.service
}

FILES:${PN} = " \
    ${libexecdir}/pir-sleep.sh \
    ${bindir}/display \
    ${systemd_system_unitdir}/pir-sleep.service \
"
