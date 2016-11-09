# This class can be used install collectd
#
# @example when declaring the collectd class
#  class { '::profiles::collectd': }
#
# @param minimum_version (Boolean)) Install this version or newer.
# @param plugins (Hash) List of plugin to install and their settings.
class profiles::collectd (
  $additional_packages = {},
  $minimum_version     = '5.5',
  $plugins             = {},
) {
  class { '::collectd':
    minimum_version => $minimum_version,
  }
  create_resources( 'package', $additional_packages, { tag => 'collectd' })
  create_resources( 'class', $plugins, { tag => 'collectd' })
  Package <| tag == collectd |> -> Class <| tag == collectd |>
}