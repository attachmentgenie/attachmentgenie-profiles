# This class can be used install collectd
#
# @example when declaring the collectd class
#  class { '::profiles::collectd': }
#
# @param additional_packages (Hash) Extra packages to install to satisfy plugin requirements
# @param manage_repo (Boolean) Configure upstream rpm repo.
# @param minimum_version (Boolean)) Install this version or newer.
# @param plugins (Hash) List of plugin to install and their settings.
class profiles::collectd (
  $additional_packages = {},
  $manage_repo         = false,
  $minimum_version     = '5.5',
  $plugins             = {},
) {
  validate_bool(
    $manage_repo,
  )
  validate_string(
    $minimum_version,
  )
  validate_hash(
    $additional_packages,
    $plugins,
  )

  class { '::collectd':
    manage_repo     => $manage_repo,
    minimum_version => $minimum_version,
  }
  create_resources( 'package', $additional_packages)
  create_resources( 'class', $plugins)
}