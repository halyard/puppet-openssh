##
# Definitions for general Linux setup
class openssh::linux {
  file { '/etc/ssh/sshd_config':
    ensure => present,
    source => 'puppet:///modules/openssh/sshd_config'
  }

  file { '/etc/ssh/authorized_keys':
    ensure => directory,
    owner  => root,
    group  => sshaccess,
    mode   => '0755'
  }

  group { 'sshaccess': }

  $openssh::users.each |String $user, Array[String] $keys| {
    $homedir = $user ? {
      'root'  => '/root',
      default => "/home/${user}"
    }
    file { "/etc/ssh/authorized_keys/${user}":
      ensure  => present,
      content => template('openssh/authorized_keys.erb')
    }
    user { $user:
      ensure     => present,
      groups     => ['sshaccess'],
      home       => $homedir,
      managehome => true
    }
  }

}
