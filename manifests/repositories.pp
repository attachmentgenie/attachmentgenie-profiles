class profiles::repositories (
  $motd = false,
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
      class { '::epel': }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }

  if $motd {
    motd::register{ 'Profile : repositories': }
  }
}