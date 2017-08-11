# This class can be used install collectd
#
# @example when declaring the collectd class
#  class { '::profiles::monitoring::collectd': }
#
# @param additional_packages Extra packages to install to satisfy plugin requirements
# @param manage_repo         Configure upstream rpm repo.
# @param minimum_version     Install this version or newer.
# @param plugins             List of plugin to install and their settings.
class profiles::monitoring::collectd (
  Hash $additional_packages = {},
  Boolean $manage_repo      = false,
  String $minimum_version   = '5.5',
  Hash$plugins              = {},
) {
  class { '::collectd':
    manage_repo     => $manage_repo,
    minimum_version => $minimum_version,
  }
  create_resources( 'package', $additional_packages)
  create_resources( 'class', $plugins)
}
