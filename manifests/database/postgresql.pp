# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::database::influxdb': }
#
# @param databases (Hash) Databases to create.
# @param encoding (String) DB encoding.
# @param ip_mask_allow_all_users (String) ip mask for allow.
# @param listen_address (String) list address
# @param manage_repo (Boolean) Manage repository.
# @param version (String) Version to install.
class profiles::database::postgresql (
  $databases               = {},
  $encoding                = 'UTF-8',
  $ip_mask_allow_all_users = '127.0.0.1/32',
  $listen_address          = 'localhost',
  $manage_repo             = false,
  $version                 = '10',
) {
  class { '::postgresql::globals':
    encoding            => $encoding,
    manage_package_repo => $manage_repo,
    version             => $version,
  }
  -> class { '::postgresql::server':
    ip_mask_allow_all_users => $ip_mask_allow_all_users,
    listen_addresses        => $listen_address,
  }
  create_resources(postgresql::server::db, $databases)

  class { '::postgresql::client': }

  profiles::bootstrap::firewall::entry { '200 allow pgsql':
    port => 5432,
  }
}
