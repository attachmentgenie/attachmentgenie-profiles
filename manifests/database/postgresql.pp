# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::database::postgresql': }
#
class profiles::database::postgresql (
  $databases                = {},
  Stdlib::Absolutepath $data_path = '/var/lib/pgsql',
  Optional[Stdlib::Absolutepath] $device = undef,
  $encoding                 = 'UTF-8',
  $ip_mask_allow_all_users  = '127.0.0.1/32',
  $listen_address           = 'localhost',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  $version                  = '11',
  Optional[Hash] $hba_rules = undef,
) {
  class { '::postgresql::globals':
    encoding            => $encoding,
    manage_package_repo => $manage_package_repo,
    version             => $version,
  }
  -> class { '::postgresql::server':
    ip_mask_allow_all_users => $ip_mask_allow_all_users,
    listen_addresses        => $listen_address,
  }
  create_resources(postgresql::server::db, $databases)

  class { '::postgresql::client': }

  if $hba_rules and $hba_rules != {} {
    create_resources(postgresql::server::pg_hba_rule, $hba_rules, { 'postgresql_version' => $version })
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'postgresql':
      device    => $device,
      mountpath => $data_path,
      before    => Package['postgresql-server'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow pgsql':
      port => 5432,
    }
  }
}
