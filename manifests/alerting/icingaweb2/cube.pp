# This class is used to setup the cube module on icingaweb2.
#
# It manages all the needed dependencies for setting up the cube module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::cube': }
#
class profiles::alerting::icingaweb2::cube (
  String $version = 'v1.1.1',
) inherits profiles::alerting::icingaweb2 {
  class { 'icingaweb2::module::cube':
    git_revision => $version,
    require      => [
      Package['git'],
    ],
  }
}
