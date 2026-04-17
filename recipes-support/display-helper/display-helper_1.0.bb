SUMMARY = "Control display power via HDMI CEC and DDC/CI"
DESCRIPTION = "Shell helper to wake, standby, or power-off an attached \
display using cec-ctl and ddcutil. Used standalone or called by pir-sleep."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://display"

RDEPENDS:${PN} = "ddcutil v4l-utils"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${WORKDIR}/display ${D}${bindir}/display
}

FILES:${PN} = "${bindir}/display"
