# This class is used to setup the ipl module on icingaweb2.
#
# It manages all the needed dependencies for setting up the ipl module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::ipl': }
#
class profiles::alerting::icingaweb2::ipl (
  String $version = 'v0.4.0',
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::ipl':
    git_revision => $version,
    require      => [
      Package['git'],
    ],
  }
}
