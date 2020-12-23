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
    'Archlinux': { include openssh::archlinux }
    'Arch': { include openssh::archlinux }
    default: { fail("Hostname module does not support ${::osfamily}") }
  }
}
