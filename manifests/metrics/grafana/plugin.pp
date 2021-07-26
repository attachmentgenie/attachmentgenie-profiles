# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::metrics::grafana::plugin { 'namevar': }
define profiles::metrics::grafana::plugin (
  Optional[Stdlib::HTTPUrl]$plugin_url = undef,
  Optional[Stdlib::HTTPUrl]$repo = undef,
) {
  grafana_plugin { $name:
    plugin_url => $plugin_url,
    repo       => $repo,
    notify     => Service['grafana'],
  }
}
