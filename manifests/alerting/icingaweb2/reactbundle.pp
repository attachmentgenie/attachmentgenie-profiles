# This class is used to setup the reactbundle module on icingaweb2.
#
# It manages all the needed dependencies for setting up the reactbundle module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::reactbundle': }
#
class profiles::alerting::icingaweb2::reactbundle (
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::reactbundle':
    require => [
      Package['git'],
    ],
  }
}
