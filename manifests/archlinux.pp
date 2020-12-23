##
# Definitions for Archlinux
class openssh::archlinux {
  package { 'openssh':
    provider => 'pacman'
  }

  -> class { 'openssh::linux': }

  -> service { 'sshd':
    ensure   => running,
    enable   => true,
    provider => 'systemd'
  }
}
