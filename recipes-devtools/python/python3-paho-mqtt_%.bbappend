FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " file://mqtt-client.py"

do_install:append() {
    install -d ${D}/scripts
    install -m 0600 ${WORKDIR}/mqtt-client.py ${D}/scripts/
}

FILES:${PN} += " /scripts/"
