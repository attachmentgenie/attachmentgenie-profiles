class profiles::ssh (
  $allowed_users = [],
  $motd          = false,
) {

  class { 'ssh::client': }
  case $::osfamily {
    'debian': {
      $print_motd = 'no'
    }
    'redhat': {
      $print_motd = 'yes'
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  class { 'ssh::server':
    allowed_users => $allowed_users,
    print_motd    => $print_motd,
  }

  if $motd {
    motd::register{ 'Profile : ssh': }
  }
}