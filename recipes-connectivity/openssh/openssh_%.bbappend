# Switch from socket-activation mode to a persistent sshd.service,
# so systemd starts sshd unconditionally at boot.
PACKAGECONFIG:remove = "systemd-sshd-socket-mode"
PACKAGECONFIG:append = " systemd-sshd-service-mode"

# Bake SSH authorized keys into root's home directory.
# Add public keys to openssh/authorized_keys, one per line.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
    file://authorized_keys \
    file://sshd_config_readonly \
    file://sshdgenkeys-readonly.service \
"

do_install:append() {
    install -d -m 0700 ${D}/home/root/.ssh
    install -m 0600 ${WORKDIR}/authorized_keys ${D}/home/root/.ssh/authorized_keys

    # Host keys on tmpfs for read-only rootfs
    install -d ${D}${sysconfdir}/ssh/sshd_config.d
    install -m 0644 ${WORKDIR}/sshd_config_readonly ${D}${sysconfdir}/ssh/sshd_config.d/readonly.conf

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sshdgenkeys-readonly.service ${D}${systemd_system_unitdir}/sshdgenkeys-readonly.service
}

SYSTEMD_SERVICE:${PN}-sshd:append = " sshdgenkeys-readonly.service"

FILES:${PN} += " \
    /home/root/.ssh/authorized_keys \
    ${sysconfdir}/ssh/sshd_config.d/readonly.conf \
    ${systemd_system_unitdir}/sshdgenkeys-readonly.service \
"
