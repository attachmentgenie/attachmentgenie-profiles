# This class is used to setup the graphite module on icingaweb2.
#
# It manages all the needed dependencies for setting up the graphite module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::graphite': }
#
class profiles::alerting::icingaweb2::graphite (
  Optional[Stdlib::Host] $host = undef,
  String $version = 'v1.1.0',
) inherits profiles::alerting::icingaweb2 {
  class { 'icingaweb2::module::graphite':
    git_revision => $version,
    url          => $host,
    require      => [
      Package['git'],
    ],
  }
}
