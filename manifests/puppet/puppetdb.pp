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
  String $database_grant = 'all',
  String $database_name = 'puppetdb',
  String $database_password = 'puppetdb',
  String $database_user = 'puppetdb',
  Boolean $install_client_tools = true,
  String $listen_address = '0.0.0.0',
  Boolean $manage_database = true,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'puppetdb',
  Array $sd_service_tags = [],
  String $ssl_listen_address = '0.0.0.0',
) {
  class { '::puppetdb::server':
    database_host      => $database_host,
    database_name      => $database_name,
    database_password  => $database_password,
    database_username  => $database_user,
    listen_address     => $listen_address,
    manage_firewall    => false,
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

  if $manage_database {
    profiles::database::postgresql::db { $database_name:
      grant    => $database_grant,
      password => $database_password,
      user     => $database_user,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '100 allow puppetdb':
      port => 8081,
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${::ipaddress}:8081",
          interval => '10s'
        }
      ],
      port   => 8081,
      tags   => $sd_service_tags,
    }
  }
}
