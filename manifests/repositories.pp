# This class can be used install user repositories properties
#
# @example when declaring the apache class
#  class { '::profiles::repositories': }
#
# @param epel (Boolean) Configure epel repository.
# @param keys (Hash) repositorie keys to import.
# @param ppas (Hash) ppas to configure.
# @param puppetlabs_deps (Boolean) Configure puppetlabs_deps repository.
# @param purge (Boolean) purge unmanaged repositories.
# @param remi (Boolean) Configure remi repository.
# @param repositories (Hash) repositories to configure.
class profiles::repositories (
  $epel            = false,
  $keys            = {},
  $ppas            = {},
  $puppetlabs_deps = false,
  $purge           = { 'sources.list.d' => true, },
  $remi            = false,
  $repositories      = {},
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
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}