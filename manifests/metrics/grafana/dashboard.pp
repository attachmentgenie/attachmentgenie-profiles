# == Type: profiles::metrics::grafana::dashboard
#
# Type to manage grafana dashboard
#
# === Examples
#
# @example when declaring the datasource class
#  profiles::metrics::grafana::dashboard { 'example':
#    content => 'path/to/exported/file.json'
#  }
#
# === Params
#
# @param content          Path to json-file.
# @param grafana_password Password for admin account.
# @param grafana_url      Grafana endpoint.
# @param grafana_user     Grafana admin user.
define profiles::metrics::grafana::dashboard (
  Optional[String] $content = undef,
  Optional[String]$grafana_password = undef,
  Optional[String]$grafana_url = undef,
  Optional[String]$grafana_user = undef,
) {
  grafana_dashboard { $name:
    content          => template( $content ),
    grafana_password => $grafana_password,
    grafana_url      => $grafana_url,
    grafana_user     => $grafana_user,
  }
}
