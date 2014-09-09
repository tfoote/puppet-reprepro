# == Class: reprepro
#
#   Configures reprepro on a server
#
# === Parameters
#
#   - *basedir*: The base directory to house the repository.
#   - *homedir*: The home directory of the reprepro user.
#
# === Example
#
#   class { 'reprepro': }
#
class reprepro (
  $basedir     = $::reprepro::params::basedir,
  $homedir     = $::reprepro::params::homedir,
  $manage_user = true,
  $user_name   = $::reprepro::params::user_name,
  $group_name  = $::reprepro::params::group_name,
) inherits reprepro::params {

  package { $::reprepro::params::package_name:
    ensure => $::reprepro::params::ensure,
  }

  if $manage_user {
    group { $group_name:
      ensure => present,
    }

    user { $user_name:
      ensure     => present,
      home       => $homedir,
      shell      => '/bin/bash',
      comment    => 'Reprepro user',
      gid        => 'reprepro',
      managehome => true,
      require    => Group[$group_name],
    }

    file { $basedir:
      ensure  => directory,
      owner   => $user_name,
      group   => $group_name,
      mode    => '0755',
      require => User[$user_name],
    }
  }

  file { "${homedir}/.gnupg":
    ensure  => directory,
    owner   => $user_name,
    group   => $group_name,
    mode    => '0700',
    require => User[$user_name],
  }

  file { "${homedir}/bin":
    ensure  => directory,
    mode    => '0755',
    owner   => $user_name,
    group   => $group_name,
    require => User[$user_name],
  }
  ->
  file { "${homedir}/bin/update-distribution.sh":
    ensure  => file,
    mode    => '0755',
    content => template('reprepro/update-distribution.sh.erb'),
    owner   => $user_name,
    group   => $group_name,
  }

}

