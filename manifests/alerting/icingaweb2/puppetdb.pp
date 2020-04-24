# This class is used to setup the puppetdb module on icingaweb2.
#
# It manages all the needed dependencies for setting up the puppetdb module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::puppetdb': }
#
class profiles::alerting::icingaweb2::puppetdb (
  String $puppetdb_host = $::fqdn,
  String $version = 'v1.0.0',
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::puppetdb':
    git_revision => $version,
    host         => $puppetdb_host,
    ssl          => 'puppet',
    require      => [
      Package['git'],
    ],
  }
}
