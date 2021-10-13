# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage::ceph
class profiles::storage::ceph (
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_firewall_entry = true,
  Boolean $mon = false,
  Boolean $osd = false,
) {
  class { 'ceph::conf': }
  if $mon {
    ceph::mon { $::hostname:
      authentication_type => 'none',
    }
  }
  if $osd {
    ceph::osd { $device: }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow ceph-mon':
      port => [6789],
    }
    profiles::bootstrap::firewall::entry { '200 allow ceph-osd':
      port => ['6800-7100'],
    }
  }
}
