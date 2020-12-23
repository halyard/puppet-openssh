##
# Definitions for systemd
class openssh::systemd {
  group { 'sshaccess': }

  -> package { 'openssh': }

  -> file { '/etc/ssh/sshd_config':
    ensure => present,
    source => 'puppet:///modules/openssh/sshd_config'
  }

  -> file { '/etc/ssh/authorized_keys':
    ensure => directory,
    owner  => root,
    group  => sshaccess,
    mode   => '0755'
  }

  -> $openssh::users.each |String $user, String $keys| {
    file { "/etc/ssh/authorized_keys/${user}":
      ensure   => present,
      content => template('openssh/authorized_keys.erb')
    }
    user { $user:
      ensure     => present,
      groups     => ['sshaccess'],
      home       => "/home/${user}",
      managehome => true
    }
  }

  -> service { 'sshd':
    ensure => running,
    enable => true,
  }
}
