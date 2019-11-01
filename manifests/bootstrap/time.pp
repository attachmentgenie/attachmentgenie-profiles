# This class can be used install time
#
# @example when declaring the time class
#  class { '::profiles::bootstrap::time': }
#
class profiles::bootstrap::time (
  String $default_timezone = 'Europe/Amsterdam',
  Array $ntp_servers       = [],
  Array $restrict          = [],
  Boolean $set_timezone    = false,
) {
  class { '::ntp':
    servers  => $ntp_servers,
    restrict => $restrict,
  }
  if $set_timezone {
    class { '::timezone':
      default_timezone => $default_timezone,
    }
  }
}
