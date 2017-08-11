# == Class: profiles::bootstrap::time
#
# This class can be used install time components.
#
# === Examples
#
# @example when declaring the time class
#  class { '::profiles::bootstrap::time': }
#
# === Parameters
#
# @param ntp_servers List of ntp servers.
# @param restrict    Restrict to this list.
# @param zone        Timezone for this node.
#
class profiles::bootstrap::time (
  Array $ntp_servers = [],
  Array $restrict    = [],
  String $zone       = 'Europe/Amsterdam',
) {
  class { '::ntp':
    servers  => $ntp_servers,
    restrict => $restrict,
  }
  class { '::timezone':
    zone     => $zone,
  }
}
