# Class to manage grafana datasources.
#
# @example when declaring the datasource class
#  profiles::metrics::grafana::datasource { 'example':
#    value => 'foo'
#  }
#
# @param access_mode      Proxy vs direct.
# @param database         Backend database.
# @param grafana_password Password for admin account.
# @param grafana_url      Grafana endpoint.
# @param grafana_user     Grafana admin user.
# @param is_default       Make datasource the default.
# @param password         Backend credential.
# @param type             Backend type.
# @param url              Backend location.
# @param user             Backend credential.
define profiles::metrics::grafana::datasource (
  Optional[String] $access_mode = undef,
  Optional[String] $database = undef,
  Optional[String] $grafana_password = undef,
  Optional[String] $grafana_url = undef,
  Optional[String] $grafana_user = undef,
  Optional[Boolean] $is_default = false,
  Optional[String] $password = undef,
  Optional[String] $type = undef,
  Optional[String] $url = undef,
  Optional[String] $user = undef,
) {
  grafana_datasource { $name:
    access_mode      => $access_mode,
    database         => $database,
    grafana_password => $grafana_password,
    grafana_url      => $grafana_url,
    grafana_user     => $grafana_user,
    is_default       => $is_default,
    password         => $password,
    type             => $type,
    url              => $url,
    user             => $user,
  }
}
