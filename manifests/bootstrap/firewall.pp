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
  class { '::firewall':
    ensure => $ensure,
  }

  resources { 'firewall':
    purge => $purge,
  }

  profiles::bootstrap::firewall::entry { '000 related,established':
    protocol => 'all',
    state    => [
      'RELATED',
      'ESTABLISHED',
    ],
  }

  profiles::bootstrap::firewall::entry { '001 accept all icmp':
    protocol => 'icmp',
  }

  profiles::bootstrap::firewall::entry { '002 accept all to lo interface':
    interface => 'lo',
    protocol  => 'all',
  }

  profiles::bootstrap::firewall::entry { '999 reject everything else':
    action   => 'reject',
    protocol => 'all',
    require  => Profiles::Bootstrap::Firewall::Entry['000 related,established'],
  }

  profiles::bootstrap::firewall::entry { '001 accept all icmp FORWARD':
    chain    => 'FORWARD',
    protocol => 'icmp',
  }

  profiles::bootstrap::firewall::entry { '999 reject everything else FORWARD':
    action   => 'reject',
    chain    => 'FORWARD',
    protocol => 'all',
  }

  create_resources( '::profiles::bootstrap::firewall::entry', $entries)
}
