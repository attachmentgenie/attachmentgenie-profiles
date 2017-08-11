# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#  class { '::profiles::bootstrap::firewall': }
#
# @param ensure Service status.
class profiles::bootstrap::firewall (
  String $ensure = 'running',
) {
  class { '::firewall':
    ensure => $ensure,
  }
}
