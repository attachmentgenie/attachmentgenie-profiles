# This class can be used install mongodb
#
# @example when declaring the mongodb class
#  class { '::profiles::database::mongodb': }
#
class profiles::database::mongodb (
  Array[Stdlib::Compat::Ip_address] $bind_ip = ['127.0.0.1'],
  Optional[String] $client_package_name = undef,
  Hash $databases = {},
  Stdlib::Absolutepath $data_path = '/var/lib/mongodb',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  Optional[String] $replset = undef,
  Optional[Array] $replset_members = undef,
  Optional[String]$server_package_name = undef,
  Optional[Boolean] $smallfiles = undef,
  Boolean $use_enterprise_repo = false,
  String $version             = '5.0.2',
) {
  class { '::mongodb::globals':
    bind_ip             => $bind_ip,
    client_package_name => $client_package_name,
    manage_package_repo => $manage_package_repo,
    server_package_name => $server_package_name,
    use_enterprise_repo => $use_enterprise_repo,
    version             => $version,
  }
  -> class { '::mongodb::server':
    smallfiles      => $smallfiles,
    replset         => $replset,
    replset_members => $replset_members,
  }
  create_resources(::profiles::database::mongodb::db, $databases)

  class { '::mongodb::client': }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'mongodb data disk':
      device    => $device,
      fs_type   => 'xfs',
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
