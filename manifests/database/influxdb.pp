# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::database::influxdb': }
#
# @param manage_repo Manage repositories.
class profiles::database::influxdb (
  Stdlib::Absolutepath $data_path = '/var/lib/influxdb',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_package_repo = false,
){
  class {'::influxdb':
    manage_repos => $manage_package_repo,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'influxdb data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Package['influxdb'],
    }
  }
  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow influxdb':
      port => [8086, 8088],
    }
  }
}
