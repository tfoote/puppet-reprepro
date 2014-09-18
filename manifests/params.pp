# == Class: reprepro::params
#
#  Global parameters
#
class reprepro::params inherits reprepro::globals {

  $ensure  = present
  $basedir = pick($basedir, '/var/packages')
  $homedir = pick($homedir, '/var/packages')

  case $::osfamily {
    Debian: {
      $package_name = pick($package_name, 'reprepro')
      $user_name    = pick($user_name,    'reprepro')
      $group_name   = pick($group_name,   'reprepro')
    }
    default: {
      fail("Unsupported osfamily: ${::osfamily}")
    }
  }

}
