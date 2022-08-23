# This class can be used install neo4j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::database::neo4j': }
#
class profiles::database::neo4j (
  Stdlib::Absolutepath $data_path = '/var/lib/neo4j/data',
  Optional[Stdlib::Absolutepath] $device = undef,
  String $install_method = 'package',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  String $version = 'installed'
) {
  class { 'neo4j' :
    install_method => $install_method,
    manage_repo    => $manage_package_repo,
    version        => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'neo4j data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Package['neo4j'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow neo4j':
      port => [7474, 7687],
    }
  }
}
