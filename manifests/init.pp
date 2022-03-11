# @summary Configure openssh server
#
class openssh (
) {
  case $facts['os']['family'] {
    'Archlinux': { include openssh::systemd }
    'Arch': { include openssh::systemd }
    default: { fail("Hostname module does not support ${facts['os']['family']}") }
  }
}
