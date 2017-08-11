# This class can be used install mongodb
#
# @example when declaring the mongodb class
#  class { '::profiles::database::mongodb': }
#
# @param client_package_name Client package to install.
# @param manage_package_repo Manage repository.
# @param mongos_package_name Package to install.
# @param server_package_name Package to install.
# @param use_enterprise_repo Install enterprise version.
# @param version             Version to install.
class profiles::database::mongodb (
  Optional[String] $client_package_name = undef,
  Boolean $manage_package_repo = false,
  Optional[String]$mongos_package_name = undef,
  Optional[String]$server_package_name = undef,
  Boolean $use_enterprise_repo = false,
  String $version             = '3.4.5',
) {
  class { '::mongodb::globals':
    client_package_name => $client_package_name,
    manage_package_repo => $manage_package_repo,
    mongos_package_name => $mongos_package_name,
    server_package_name => $server_package_name,
    use_enterprise_repo => $use_enterprise_repo,
    version             => $version,
  }
  -> class { '::mongodb::server': }

  class { '::mongodb::client': }
}
