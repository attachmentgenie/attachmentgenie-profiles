# This class is used to setup the fileshipper module on icingaweb2.
#
# It manages all the needed dependencies for setting up the fileshipper module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::fileshipper': }
#
class profiles::alerting::icingaweb2::fileshipper (
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::fileshipper':
    require => [
      Package['git'],
    ],
  }
}
