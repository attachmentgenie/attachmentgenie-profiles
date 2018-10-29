# This class can be used install collectd
#
# @example when declaring the collectd class
#  class { '::profiles::monitoring::collectd': }
#
# @param additional_packages Extra packages to install to satisfy plugin requirements
# @param manage_repo         Configure upstream rpm repo.
# @param manage_service      Run collectd as a service.
# @param minimum_version     Install this version or newer.
# @param plugins             List of plugin to install and their settings.
# @param purge_config        Purge default config file.
class profiles::monitoring::collectd (
  Hash $additional_packages = {},
  Boolean $manage_repo      = false,
  Boolean $manage_service   = true,
  String $minimum_version   = '5.5',
  Hash $plugins             = {},
  Boolean $purge_config     = false
) {
  class { '::collectd':
    manage_repo     => $manage_repo,
    manage_service  => $manage_service,
    minimum_version => $minimum_version,
    purge_config    => $purge_config,
  }
  create_resources( 'package', $additional_packages)
  create_resources( 'class', $plugins)
}
