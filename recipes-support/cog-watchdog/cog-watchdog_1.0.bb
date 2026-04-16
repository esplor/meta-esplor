SUMMARY = "Force reboot on vc4 GPU reset cascade that wedges cog"
DESCRIPTION = "Detects the 'Resetting GPU' reset-loop pattern that leaves \
the DRM atomic-commit worker parked on an orphaned dma-fence (cog in \
D-state, systemctl cannot recover), and issues a SysRq reboot. Also \
installs a sysctl drop-in enabling SysRq and hung-task panic as a \
fallback recovery path."
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = " \
    file://cog-watchdog.sh \
    file://cog-watchdog.service \
    file://cog-watchdog.timer \
    file://99-cog-watchdog.conf \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "cog-watchdog.timer"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}${libexecdir}
    install -m 0755 ${WORKDIR}/cog-watchdog.sh ${D}${libexecdir}/cog-watchdog.sh

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/cog-watchdog.service ${D}${systemd_system_unitdir}/cog-watchdog.service
    install -m 0644 ${WORKDIR}/cog-watchdog.timer ${D}${systemd_system_unitdir}/cog-watchdog.timer

    install -d ${D}${sysconfdir}/sysctl.d
    install -m 0644 ${WORKDIR}/99-cog-watchdog.conf ${D}${sysconfdir}/sysctl.d/99-cog-watchdog.conf
}

FILES:${PN} = " \
    ${libexecdir}/cog-watchdog.sh \
    ${systemd_system_unitdir}/cog-watchdog.service \
    ${systemd_system_unitdir}/cog-watchdog.timer \
    ${sysconfdir}/sysctl.d/99-cog-watchdog.conf \
"
