# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::icinga2_web': }
#
# @param manage_repo (Boolean) Manage icinga2 web repos.
# @param manage_package (Boolean) Manage web package.
class profiles::icinga2_web (
  $manage_package = false,
  $manage_repo    = false,
) {
  validate_bool(
    $manage_package,
    $manage_repo,
  )
  class { '::icingaweb2':
    manage_package => $manage_package,
    manage_repo    => $manage_repo,
  }
}
