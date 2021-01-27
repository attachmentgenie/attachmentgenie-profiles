# This class can be used install mongodb
#
# @example when declaring the mongodb class
#  class { '::profiles::database::mongodb': }
#
class profiles::database::mongodb (
  Optional[String] $client_package_name = undef,
  Stdlib::Absolutepath $data_path = '/var/lib/mongodb',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  Optional[String]$mongos_package_name = undef,
  Optional[String]$server_package_name = undef,
  Boolean $use_enterprise_repo = false,
  String $version             = '4.4.3',
) {
  class { '::mongodb::globals':
    client_package_name => $client_package_name,
    manage_package_repo => $manage_package_repo,
    server_package_name => $server_package_name,
    use_enterprise_repo => $use_enterprise_repo,
    version             => $version,
  }
  -> class { '::mongodb::server': }

  class { '::mongodb::client': }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'mongodb data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Package['mongodb_server'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow mongodb':
      port => 27017,
    }
  }
}
