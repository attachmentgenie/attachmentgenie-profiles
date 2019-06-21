# This class can be used install user puppetdb properties
#
# @example when declaring the puppetdb class
#  class { '::profiles::puppet::puppetdb': }
#
# @param database_host      Db host.
# @param database_password  Db password.
# @param listen_address     Interface to bind to.
# @param manage_firewall    Manage firewall entries.
# @param ssl_listen_address Interface to bind ssl to.
class profiles::puppet::puppetdb (
  String $database_host = 'localhost',
  String $database_password = 'puppetdb',
  Boolean $install_client_tools = true,
  String $listen_address = '0.0.0.0',
  Boolean $manage_firewall = false,
  String $ssl_listen_address = '0.0.0.0',
) {
  class { '::puppetdb::server':
    database_host      => $database_host,
    database_password  => $database_password,
    listen_address     => $listen_address,
    manage_firewall    => $manage_firewall,
    ssl_listen_address => $ssl_listen_address,
  }

  if $install_client_tools {
    if versioncmp($::puppetversion, '6.0.0') >= 0 {
      package { 'puppetdb_cli':
        ensure          => installed,
        install_options => ['--bindir', '/opt/puppetlabs/bin'],
        provider        => puppet_gem,
      }
    } else {
      package { 'puppet-client-tools':
        ensure => installed,
      }
    }
  }

  profiles::bootstrap::firewall::entry { '100 allow puppetdb':
    port => 8081,
  }
}
