# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param databases (Hash) Databases to create.
# @param manage_package_repo (Boolean) Manage repository.
# @param version (String) Version to install.
class profiles::postgresql (
  $databases            = {},
  $manage_package_repo  = false,
  $version              = '9.5',
) {
  validate_bool(
    $manage_package_repo,
  )
  validate_hash(
    $databases,
  )
  validate_string(
    $version,
  )
  class { '::postgresql::globals':
    manage_package_repo => $manage_package_repo,
    version             => $version,
  } ->
  class { '::postgresql::server': }
  create_resources(postgresql::server::db, $databases)

  class { '::postgresql::client': }
}