# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#  class { '::profiles::firewall': }
#
# @param ensure (Hash) Service status.
class profiles::firewall (
  $ensure = 'running',
) {
  class { '::firewall':
    ensure => $ensure,
  }
}