# This class can be used install user repositories properties
#
# @example when declaring the apache class
#  class { '::profiles::repositories': }
#
# @param epel (Boolean) Configure epel repository.
# @param remi (Boolean) Configure remi repository.
class profiles::repositories (
  $epel = false,
  $remi = false,
){

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
      if $remi {
        yumrepo { 'remi':
          descr      => "Remi's RPM repository for Enterprise Linux ${::operatingsystemmajrelease} - \$basearch",
          baseurl    => 'absent',
          mirrorlist => "http://rpms.remirepo.net/enterprise/${::operatingsystemmajrelease}/remi/mirror",
          enabled    => 1,
          gpgcheck   => 0,
        }
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}