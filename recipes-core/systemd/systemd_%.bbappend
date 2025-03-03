SUMMARY = "Integrate wpa credentials"
LICENSE = "MIT"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
