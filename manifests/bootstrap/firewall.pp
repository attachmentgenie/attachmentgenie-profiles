# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#  class { '::profiles::bootstrap::firewall': }
#
# @param ensure   Service status.
# @param entries  Firewall entries.
# @param purge    Remove unmanaged firewall entries.
class profiles::bootstrap::firewall (
  String $ensure = 'running',
  Hash $entries = {},
  Boolean $purge = true,
) {
  class { 'firewall':
    ensure => $ensure,
  }

  resources { 'firewall':
    purge => $purge,
  }

  profiles::bootstrap::firewall::entry { '000 related,established':
    proto => 'all',
    state => [
      'RELATED',
      'ESTABLISHED',
    ],
  }

  create_resources( '::profiles::bootstrap::firewall::entry', $entries)

  firewallchain { 'INPUT:filter:IPv4':
    ensure => present,
    policy => drop,
    before => undef,
  }
}
