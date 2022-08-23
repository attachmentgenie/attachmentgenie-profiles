# This class is used to setup the incubator module on icingaweb2.
#
# It manages all the needed dependencies for setting up the incubator module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::incubator': }
#
class profiles::alerting::icingaweb2::incubator (
  String $version = 'v0.6.0',
) inherits profiles::alerting::icingaweb2 {
  class { 'icingaweb2::module::incubator':
    git_revision => $version,
    require      => [
      Package['git'],
    ],
  }
}
