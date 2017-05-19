# This class can be used install user repositories properties
#
# @example when declaring the repositories class
#  class { '::profiles::repositories': }
#
# @param backports (Boolean) Configure backports repository (debian family).
# @param epel (Boolean) Configure epel repository (redhat family).
# @param keys (Hash) repositorie keys to import.
# @param ppas (Hash) ppas to configure (ubuntu only).
# @param puppetlabs_deps (Boolean) Configure puppetlabs_deps repository (debian family).
# @param purge (Boolean) purge unmanaged repositories.
# @param remi (Boolean) Configure remi repository (redhat family).
# @param repositories (Hash) repositories to configure.
class profiles::repositories (
  $backports       = false,
  $epel            = false,
  $keys            = {},
  $ppas            = {},
  $puppetlabs_deps = false,
  $purge           = { 'sources.list.d' => true, },
  $remi            = false,
  $repositories    = {},
){
  validate_bool(
    $epel,
    $puppetlabs_deps,
    $remi,
  )
  validate_hash(
    $keys,
    $ppas,
    $purge,
    $repositories,
  )
  case $::osfamily {
    'debian': {
      class { 'apt':
        keys    => $keys,
        ppas    => $ppas,
        purge   => $purge,
        sources => $repositories,
      }
      if $backports {
        class { 'apt::backports':
          location => 'http://ftp.de.debian.org/debian',
          release  => "${::lsbdistcodename}-backports",
          repos    => 'main',
          pin      => 500,
        }
      }

    }
    'redhat': {
      if $epel {
        class { '::epel': }
        Yumrepo['epel'] -> Package <||>
      }
      if $puppetlabs_deps {
        yumrepo { 'puppetlabs-deps':
          descr    => 'Puppet Labs Packages',
          baseurl  => "http://yum.puppetlabs.com/el/${::operatingsystemmajrelease}/dependencies/\$basearch",
          enabled  => 1,
          gpgcheck => 0,
        }
        Yumrepo['puppetlabs-deps'] -> Package <||>
      }
      if $remi {
        yumrepo { 'remi':
          descr      => "Remi's RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
          baseurl    => 'absent',
          mirrorlist => "http://rpms.remirepo.net/enterprise/${::operatingsystemmajrelease}/remi/mirror",
          enabled    => 1,
          gpgcheck   => 0,
        }
        Yumrepo['remi'] -> Package <||>
      }

      # add extra repositories
      $yum_defaults = {
        enabled  => 1,
        gpgcheck => 1,
      }
      create_resources( 'yumrepo', $repositories, $yum_defaults )
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
