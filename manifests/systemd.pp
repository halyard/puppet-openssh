##
# Definitions for general Linux setup
class openssh::systemd {
  $package_name = $facts['os']['family'] ? {
    /(Debian|Ubuntu)/ => 'openssh-server',
    default           => 'openssh',
  }

  package { $package_name: }

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

  file { '/etc/sudoers.d/wheel':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => '%wheel ALL=(ALL:ALL) NOPASSWD: ALL',
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

    $usergroups = $user in $openssh::sudoers ? {
      true  => ['sshaccess', 'wheel'],
      false => ['sshaccess'],
    }

    user { $user:
      ensure     => present,
      groups     => $usergroups,
      home       => $homedir,
      managehome => true,
      password   => '*',
    }
  }
}
