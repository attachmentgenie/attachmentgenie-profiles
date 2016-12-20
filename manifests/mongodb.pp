# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param manage_package_repo (Boolean) Manage repository.
# @param version (String) Version to install.
class profiles::mongodb (
  $manage_package_repo  = false,
  $version              = '3.4.0',
) {
  validate_bool(
    $manage_package_repo,
  )
  validate_string(
    $version,
  )
  class { '::mongodb::globals':
    manage_package_repo => $manage_package_repo,
    version             => $version,
  } ->
  class { '::mongodb::server': }

  class { '::mongodb::client': }
}