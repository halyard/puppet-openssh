# @summary Configure openssh server
#
# @param users defines user/key mappings
# @param sudoers defines users that can sudo to root
class openssh (
  Hash[String, Array[String]] $users = [],
  Array[String] $sudoers = [],
) {
  case $facts['os']['family'] {
    'Archlinux': { include openssh::systemd }
    'Arch': { include openssh::systemd }
    'Debian': { include openssh::systemd }
    default: { fail("module does not support ${facts['os']['family']}") }
  }
}
