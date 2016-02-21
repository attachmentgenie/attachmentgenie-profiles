class profiles::time (
  $motd     = false,
  $restrict = [],
  $zone     = 'Europe/Amsterdam',
) {

  class { 'ntp':
    restrict => $restrict,
  }
  class { 'timezone':
    zone     => $zone,
  }

  if $motd {
    motd::register{ 'Profile : time': }
  }
}