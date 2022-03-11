# @summary Configure openssh server
#
# @param users defines user/key mappings
class openssh (
  Hash[String, Array[String]] $users = []
) {
  case $facts['os']['family'] {
    'Archlinux': { include openssh::systemd }
    'Arch': { include openssh::systemd }
    default: { fail("Hostname module does not support ${facts['os']['family']}") }
  }
}
