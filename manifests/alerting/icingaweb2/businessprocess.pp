# This class is used to setup the businessprocess module on icingaweb2.
#
# It manages all the needed dependencies for setting up the businessprocess module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::businessprocess': }
#
class profiles::alerting::icingaweb2::businessprocess (
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::businessprocess':
    require => [
      Package['git'],
    ],
  }
}
