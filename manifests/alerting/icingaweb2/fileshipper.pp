# This class is used to setup the fileshipper module on icingaweb2.
#
# It manages all the needed dependencies for setting up the fileshipper module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::fileshipper': }
#
class profiles::alerting::icingaweb2::fileshipper (
  String $version = 'v1.1.0',
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::fileshipper':
    git_revision => $version,
    require      => [
      Package['git'],
    ],
  }
}
