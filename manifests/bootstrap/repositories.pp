# This class can be used install user repositories properties
#
# @example when declaring the repositories class
#  class { '::profiles::bootstrap::repositories': }
#
# @param backports       Configure backports repository (debian family).
# @param epel            Configure epel repository (redhat family).
# @param keys            Repositorie keys to import.
# @param ppas            PPAS to configure (ubuntu only).
# @param puppetlabs_deps Configure puppetlabs_deps repository (debian family).
# @param purge           Purge unmanaged repositories.
# @param remi            Configure remi repository (redhat family).
# @param repositories    Repositories to configure.
class profiles::bootstrap::repositories (
  Boolean $backports       = false,
  Boolean $epel            = false,
  Hash $keys               = {},
  Hash $ppas               = {},
  Boolean $puppetlabs_deps = false,
  Hash $purge              = { 'sources.list.d' => true, },
  Boolean $remi            = false,
  Hash $repositories       = {},
){
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
