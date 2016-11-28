# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::influxdb': }
#
# @param manage_package_repo (Boolean) Manage repository.
# @param version (String) Version to install.
class profiles::postgresql (
  $manage_package_repo  = false,
  $version              = '9.5',
) {
  class { '::postgresql::globals':
    manage_package_repo => $manage_package_repo,
    version             => $version,
  } ->
  class { '::postgresql::server': }
  class { '::postgresql::client': }
}