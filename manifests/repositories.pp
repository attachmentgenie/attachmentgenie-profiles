class profiles::repositories (
  $motd = false,
  $epel = true,
  $remi = true,
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

  if $motd {
    motd::register{ 'Profile : repositories': }
  }
}
