# Class to manage grafana datasources.
#
# @example when declaring the datasource class
#  profiles::grafana::datasource { 'example':
#    value => 'foo'
#  }
#
# @param access_mode (String) Proxy vs direct.
# @param database (String) Backend database.
# @param grafana_password (String) Password for admin account.
# @param grafana_url (String) Grafana endpoint.
# @param grafana_user (String) Grafana admin user.
# @param is_default (Boolean) Make datasource the default.
# @param password (String) backend credential.
# @param type (String) backend type.
# @param url (String) backend location.
# @param user (string) Backend credential.
define profiles::grafana::datasource (
  $access_mode      = undef,
  $database         = undef,
  $grafana_password = undef,
  $grafana_url      = undef,
  $grafana_user     = undef,
  $is_default       = false,
  $password         = undef,
  $type             = undef,
  $url              = undef,
  $user             = undef,
) {
  validate_bool(
    $is_default,
  )
  validate_string(
    $grafana_password,
    $grafana_user,
    $grafana_url,
    $type,
  )
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