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
# @param default_timezone Timezone for this node.
# @param ntp_servers      List of ntp servers.
# @param restrict         Restrict to this list.
#
class profiles::bootstrap::time (
  String $default_timezone = 'Europe/Amsterdam',
  Array $ntp_servers       = [],
  Array $restrict          = [],
) {
  class { '::ntp':
    servers  => $ntp_servers,
    restrict => $restrict,
  }
  class { '::timezone':
    default_timezone => $default_timezone,
  }
}
