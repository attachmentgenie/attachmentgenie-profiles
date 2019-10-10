# This class is used to setup the cube module on icingaweb2.
#
# It manages all the needed dependencies for setting up the cube module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::cube': }
#
class profiles::alerting::icingaweb2::cube (
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::cube':
    require => [
      Package['git'],
    ],
  }
}
