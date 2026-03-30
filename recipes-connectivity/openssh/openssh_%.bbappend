# Switch from socket-activation mode to a persistent sshd.service,
# so systemd starts sshd unconditionally at boot.
PACKAGECONFIG:remove = "systemd-sshd-socket-mode"
PACKAGECONFIG:append = " systemd-sshd-service-mode"

# Bake SSH authorized keys into root's home directory.
# Add public keys to openssh/authorized_keys, one per line.
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://authorized_keys"

do_install:append() {
    install -d -m 0700 ${D}/home/root/.ssh
    install -m 0600 ${WORKDIR}/authorized_keys ${D}/home/root/.ssh/authorized_keys
}

FILES:${PN} += "/home/root/.ssh/authorized_keys"
