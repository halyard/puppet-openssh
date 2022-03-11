##
# Definitions for general Linux setup
class openssh::systemd {
  package { 'openssh': }

  -> file { '/etc/ssh/sshd_config':
    ensure => file,
    source => 'puppet:///modules/openssh/sshd_config',
  }

  ~> service { 'sshd':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
  }

  group { 'sshaccess': }

  file { '/etc/ssh/authorized_keys':
    ensure => directory,
    owner  => root,
    group  => sshaccess,
    mode   => '0755',
  }

  $openssh::users.each |String $user, Array[String] $keys| {
    $homedir = $user ? {
      'root'  => '/root',
      default => "/home/${user}",
    }
    file { "/etc/ssh/authorized_keys/${user}":
      ensure  => file,
      content => template('openssh/authorized_keys.erb'),
    }
    user { $user:
      ensure     => present,
      groups     => ['sshaccess'],
      home       => $homedir,
      managehome => true,
    }
  }
}
