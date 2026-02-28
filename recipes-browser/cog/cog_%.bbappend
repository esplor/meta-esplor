FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://cog.service \
    file://cog-url.service \
    file://cog-read-url.sh \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "cog.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/cog.service ${D}${systemd_system_unitdir}/cog.service
    install -m 0644 ${WORKDIR}/cog-url.service ${D}${systemd_system_unitdir}/cog-url.service

    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/cog-read-url.sh ${D}${libexecdir}/cog-read-url.sh
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/cog.service \
    ${systemd_system_unitdir}/cog-url.service \
    ${libexecdir}/cog-read-url.sh \
"
