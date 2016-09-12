# This class can be used install collectd
#
# @example when declaring the collectd class
#  class { '::profiles::collectd': }
#
# @param minimum_version (Boolean)) Install this version or newer.
class profiles::collectd (
  $minimum_version = '5.5',
) {
  class { '::collectd':
    minimum_version => $minimum_version,
  }
}