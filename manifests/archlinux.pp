##
# Definitions for Archlinux
class openssh::archlinux {
  package { 'openssh':
    provider => 'pacman'
  }

  -> class { 'openssh::linux':
    notify => Service['sshd']
  }

  -> service { 'sshd':
    ensure   => running,
    enable   => true,
    provider => 'systemd'
  }
}
