# This class can be used install user foreman properties
#
# @example when declaring the foreman class
#  class { '::profiles::puppet::foreman': }
#
# @param database_host          Db host.
# @param db_manage_rake         Manage the DB rake jobs.
# @param database_password      Db password.
# @param foreman_admin_password Foreman admin password.
# @param foreman_host           Foreman fqdn.
# @param foreman_repo           Foreman repo to use.
# @param oauth_consumer_key     oauth_consumer_key.
# @param oauth_consumer_secret  oauth_consumer_secret.
# @param plugins                Foreman plugins to install.
# @param protocol               Protocol to reach Foreman.
# @param selinux                Install foreman-selinux.
# @param server_ssl_ca          SSL ca.
# @param server_ssl_chain       SSL chain.
# @param server_ssl_cert        SSL cert.
# @param server_ssl_key         SSL key.
# @param server_ssl_crl         SSL crl.
# @param settings               List of foreman settings.
# @param unattended             Allow unattended installs.
class profiles::puppet::foreman (
  String $database_host           = 'localhost',
  String $database_grant          = 'all',
  String $database_name           = 'foreman',
  String $database_password       = 'foreman',
  String $database_user           = 'foreman',
  Boolean $db_manage_rake         = true,
  Boolean $expose_metrics         = false,
  String $foreman_admin_password  = 'secret',
  String $foreman_host            = $facts['networking']['fqdn'],
  String $foreman_repo            = '2.3',
  Boolean $manage_database        = true,
  Boolean $manage_firewall_entry  = true,
  Boolean $manage_sd_service      = false,
  String $oauth_consumer_key      = 'secret',
  String $oauth_consumer_secret   = 'secret',
  Hash $plugins                   = {},
  Enum['http', 'https'] $protocol = 'https',
  String $sd_service_name         = 'foreman',
  Array $sd_service_tags          = ['metrics'],
  Boolean $selinux                = false,
  String $server_ssl_ca           = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  String $server_ssl_chain        = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  String $server_ssl_cert         = "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
  String $server_ssl_key          = "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
  String $server_ssl_crl          = '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem',
  Hash $settings                  = {},
  Boolean $unattended             = true,
) inherits profiles::puppet::foreman::params {
  if $protocol == 'https' {
    $ssl = true
  } else {
    $ssl = false
  }
  class { 'foreman::repo':
    repo => $foreman_repo,
  }
  -> class { 'foreman':
    db_database                  => $database_name,
    db_host                      => $database_host,
    db_manage                    => false,
    db_manage_rake               => $db_manage_rake,
    db_password                  => $database_password,
    db_username                  => $database_user,
    foreman_url                  => "${protocol}://${foreman_host}",
    initial_admin_password       => $foreman_admin_password,
    oauth_consumer_key           => $oauth_consumer_key,
    oauth_consumer_secret        => $oauth_consumer_secret,
    ssl                          => $ssl,
    server_ssl_ca                => $server_ssl_ca,
    server_ssl_chain             => $server_ssl_chain,
    server_ssl_cert              => $server_ssl_cert,
    server_ssl_key               => $server_ssl_key,
    server_ssl_crl               => $server_ssl_crl,
    telemetry_prometheus_enabled => $expose_metrics,
    unattended                   => $unattended,
  }
  class { 'foreman::cli':
    foreman_url => "${protocol}://${foreman_host}",
    username    => 'admin',
    password    => $foreman_admin_password,
  }
  create_resources(::profiles::puppet::foreman::plugin, $plugins)
  $settings_defaults = {
    tag => 'do_a',
  }
  create_resources(::profiles::puppet::foreman::setting, $settings, $settings_defaults)

  if $manage_database {
    profiles::database::postgresql::db { $database_name:
      grant    => $database_grant,
      password => $database_password,
      user     => $database_user,
    }

    Profiles::Database::Postgresql::Db[$database_name] -> Exec['foreman-rake-db:migrate']
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '100 allow foreman':
      port => 80,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${facts['networking']['ip']}",
          interval => '10s'
        },
      ],
      port   => 80,
      tags   => $sd_service_tags,
    }
  }
}
