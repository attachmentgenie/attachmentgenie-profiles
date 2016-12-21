# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param databases (Hash) Databases to create.
# @param encoding (String) DB encoding.
# @param ip_mask_allow_all_users (String) ip mask for allow.
# @param listen_address (String) list address
# @param manage_package_repo (Boolean) Manage repository.
# @param version (String) Version to install.
class profiles::postgresql (
  $databases               = {},
  $encoding                = 'UTF-8',
  $ip_mask_allow_all_users = '127.0.0.1/32',
  $listen_address          = 'localhost',
  $manage_package_repo     = false,
  $version                 = '9.5',
) {
  validate_bool(
    $manage_package_repo,
  )
  validate_hash(
    $databases,
  )
  validate_string(
    $encoding,
    $ip_mask_allow_all_users,
    $listen_address,
    $version,
  )
  class { '::postgresql::globals':
    encoding            => $encoding,
    manage_package_repo => $manage_package_repo,
    version             => $version,
  } ->
  class { '::postgresql::server':
    ip_mask_allow_all_users => $ip_mask_allow_all_users,
    listen_addresses        => $listen_address,
  }
  create_resources(postgresql::server::db, $databases)

  class { '::postgresql::client': }
}