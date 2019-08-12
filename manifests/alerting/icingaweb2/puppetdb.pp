# This class is used to setup the puppetdb module on icingaweb2.
#
# It manages all the needed dependencies for setting up the puppetdb module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::puppetdb': }
#
class profiles::alerting::icingaweb2::puppetdb (
    $puppetdb_host = $::fqdn,
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::puppetdb':
    host    => $puppetdb_host,
    ssl     => 'puppet',
    require => [
      Package['git'],
    ],
  }
}
