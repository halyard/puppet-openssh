# == Class: hostname
#
# Set up openssh server
#
# === Parameters
#
# === Example
#
#   class { 'openssh': }
#

class openssh (
  Hash[String, Array[String]] $users = []
) {
  case $::osfamily {
    'Archlinux': { include openssh::systemd }
    'Arch': { include openssh::systemd }
    default: { fail("Hostname module does not support ${::osfamily}") }
  }
}
