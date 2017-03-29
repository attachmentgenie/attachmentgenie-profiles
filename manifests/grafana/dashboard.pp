# == Type: profiles::grafana::dashboard
#
# Type to manage grafana dashboard
#
# === Examples
#
# @example when declaring the datasource class
#  profiles::grafana::dashboard { 'example':
#    content => 'path/to/exported/file.json'
#  }
#
# === Params
#
# @param content [String] Path to json-file.
# @param grafana_password [String] Password for admin account.
# @param grafana_url [String] Grafana endpoint.
# @param grafana_user [String] Grafana admin user.
#
define profiles::grafana::dashboard (
  $content          = undef,
  $grafana_password = undef,
  $grafana_url      = undef,
  $grafana_user     = undef,
) {

  validate_string(
    $content,
    $grafana_password,
    $grafana_url,
    $grafana_user,
  )

  grafana_dashboard { $name:
    content          => template( $content ),
    grafana_password => $grafana_password,
    grafana_url      => $grafana_url,
    grafana_user     => $grafana_user,
  }
}
