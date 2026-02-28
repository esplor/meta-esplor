# Switch from socket-activation mode to a persistent sshd.service,
# so systemd starts sshd unconditionally at boot.
PACKAGECONFIG:remove = "systemd-sshd-socket-mode"
PACKAGECONFIG:append = " systemd-sshd-service-mode"
