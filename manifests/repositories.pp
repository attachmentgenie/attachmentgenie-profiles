# This class can be used install user repositories properties
#
# @example when declaring the apache class
#  class { '::profiles::repositories': }
#
# @param epel (Boolean) Configure epel repository.
# @param puppetlabs_deps (Boolean) Configure puppetlabs_deps repository.
# @param remi (Boolean) Configure remi repository.
class profiles::repositories (
  $epel            = false,
  $puppetlabs_deps = false,
  $remi            = false,
){
  validate_bool(
    $epel,
    $puppetlabs_deps,
    $remi,
  )
  case $::osfamily {
    'debian': {
      class { 'apt':
        purge => {
          purge_sources_list_d => true,
        },
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