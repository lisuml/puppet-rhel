# Class: rhel::epel
#
class rhel::epel (
  $ensure = undef,
  # These *will* break. But will not get fixed. See :
  # https://fedorahosted.org/fedora-infrastructure/ticket/3605
  $release_rpm5 = 'epel-release-5-4.noarch.rpm',
  $release_rpm6 = 'epel-release-6-8.noarch.rpm',
) {

  if $::osfamily != 'RedHat' {
    fail ("Class ${title} is not supported on ${::osfamily} OS family")
  }

  case $::operatingsystemmajrelease {
    '5': { $release_rpm = $release_rpm5 }
    '6': { $release_rpm = $release_rpm6 }
  }

  if $ensure == 'absent' {

    package { 'epel-release': ensure => absent }

  } else {

    # We need to short-circuit puppet's package provider for this
    exec { 'yum install epel-release':
      command => "yum -y --nogpgcheck install http://download.fedoraproject.org/pub/epel/${::operatingsystemmajrelease}/i386/${release_rpm}",
      path    => [ '/bin', '/usr/bin' ],
      unless  => 'rpm -q epel-release',
    }

  }

}
