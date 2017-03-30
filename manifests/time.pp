# == Class: profiles::time
#
# This class can be used install time components.
#
# === Examples
#
# @example when declaring the time class
#  class { '::profiles::time': }
#
# === Parameters
#
# @param ntp_servers [Array] list of ntp servers.
# @param restrict [Array] Restrict to this list.
# @param zone [String] Timezone for this node.
#
class profiles::time (
  $ntp_servers = [],
  $restrict    = [],
  $zone        = 'Europe/Amsterdam',
) {
  validate_array(
    $ntp_servers,
    $restrict,
  )
  validate_string(
    $zone,
  )
  class { '::ntp':
    servers  => $ntp_servers,
    restrict => $restrict,
  }
  class { '::timezone':
    zone     => $zone,
  }
}
