# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param client_package_name (String) client package to install.
# @param manage_package_repo (Boolean) Manage repository.
# @param mongos_package_name (String) mongos package to install.
# @param server_package_name (String) Package to install.
# @param use_enterprise_repo (Boolean)
# @param version (String) Version to install.
class profiles::mongodb (
  $client_package_name = undef,
  $manage_package_repo = false,
  $mongos_package_name = undef,
  $server_package_name = undef,
  $use_enterprise_repo = false,
  $version             = '3.4.2',
) {
  validate_bool(
    $manage_package_repo,
  )
  validate_string(
    $version,
  )
  class { '::mongodb::globals':
    client_package_name => $client_package_name,
    manage_package_repo => $manage_package_repo,
    mongos_package_name => $mongos_package_name,
    server_package_name => $server_package_name,
    use_enterprise_repo => $use_enterprise_repo,
    version             => $version,
  } ->
  class { '::mongodb::server': }

  class { '::mongodb::client': }
}
