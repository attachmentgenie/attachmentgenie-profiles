# This class is used to setup the businessprocess module on icingaweb2.
#
# It manages all the needed dependencies for setting up the businessprocess module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::businessprocess': }
#
class profiles::alerting::icingaweb2::businessprocess (
  $version = 'v2.2.0',
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::businessprocess':
    git_revision => $version,
    require      => [
      Package['git'],
    ],
  }
}
