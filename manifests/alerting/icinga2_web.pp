# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::alerting::icinga2_web': }
#
# @param manage_repo    Manage icinga2 web repos.
# @param manage_package Manage web package.
class profiles::alerting::icinga2_web (
  Boolean $manage_package = false,
  Boolean $manage_repo = false,
) {
  class { '::icingaweb2':
    manage_package => $manage_package,
    manage_repo    => $manage_repo,
  }
}
