# == Class: profiles::metrics::grafana
#
# This class can be used to setup grafana.
#
# === Examples
#
# @example when declaring the node role
#  class { '::profiles::metrics::grafana': }
#
# === Parameters
#
# @param allow_sign_up               Allow users to sign up
# @param allow_org_create            Allow organisations to be setup.
# @param auto_assign_org             Automatically asign an organisation.
# @param auth_assign_org_role        Basic role.
# @param admin_password              Admin password.
# @param admin_user                  Admin username
# @param cookie_username             Cookie name
# @param cookie_remember_name        Cookie remember setting
# @param dashboards                  Set of dashboards to load
# @param data_source_proxy_whitelist Proxy Whitelist.
# @param datasources                 List of datasources.
# @param db_datadir                  Directory to store data in.
# @param db_host                     Db connection string
# @param db_name                     DB name.
# @param db_password                 DB password.
# @param db_path                     DB path [sqlite only]
# @param db_type                     DB type,
# @param db_user                     DB user.
# @param disable_gravatar            Disable gravatar downloadingg
# @param domain                      Part of the root_url.
# @param extra_cfg                   Additional configuration to pass to grafana
# @param install_method              How to install grafana.
# @param http_addr                   Address to bing to.
# @param log_buffer_length           Log bufeer length
# @param log_rotate                  Log rotation
# @param log_max_lines               Log max size
# @param log_max_lines_shift         Log max lines shift
# @param log_daily_rotate            Rotate log daily.
# @param login_remember_days         Remember Login.
# @param log_level                   Loglevel
# @param log_max_days                Keep logs for max days.
# @param logmode                     Type of logging
# @param manage_repo                 Manage repo.
# @param plugins                     Plugins to install.
# @param rpm_iteration               RPM iteration to install.
# @param root_url                    Full URL used to access Grafana from a web browser.
# @param secret_key                  Secret key.
# @param smtp_enable                 Enable smtp.
# @param smtp_from_address           Address used when sending out emails.
# @param smtp_from_name              Name to be used when sending out emails.
# @param smtp_host                   SMTP-server to use.
# @param version                     Version to install.
#
class profiles::metrics::grafana (
  Boolean $allow_sign_up                        = false,
  Boolean $allow_org_create                     = false,
  Boolean $auto_assign_org                      = true,
  String $auth_assign_org_role                  = 'Viewer',
  String $admin_password                        = 'secret',
  String $admin_user                            = 'admin',
  String $cookie_username                       = 'grafana_user',
  String $cookie_remember_name                  = 'grafana_remember',
  String $data_source_proxy_whitelist           = '', # lint:ignore:params_empty_string_assignment
  Hash $dashboards                              = {},
  Hash $datasources                             = {},
  String $db_datadir                            = '/var/lib/pgsql/data',
  String $db_grant                              = 'all',
  Stdlib::Host $db_host                         = '127.0.0.1',
  String $db_name                               = 'grafana',
  String $db_password                           = '', # lint:ignore:params_empty_string_assignment
  Stdlib::Port $db_port                         = 5432,
  Optional[String] $db_path                     = undef,
  Enum['mysql', 'postgres', 'sqlite3'] $db_type = 'sqlite3',
  String $db_user                               = '', # lint:ignore:params_empty_string_assignment
  String $default_org                           = 'Main Org.',
  Boolean $disable_gravatar                     = false,
  String $domain                                = 'localhost',
  Hash $extra_cfg                               = {},
  String $http_addr                             = '127.0.0.1',
  String $install_method                        = 'repo',
  Integer $log_buffer_length                    = 10000,
  Boolean $log_rotate                           = true,
  Integer $log_max_lines                        = 1000000,
  Integer $log_max_lines_shift                  = 28,
  Boolean $log_daily_rotate                     = true,
  Integer $login_remember_days                  = 7,
  String $log_level                             = 'Info',
  Integer $log_max_days                         = 7,
  String $logmode                               = 'console, file',
  Boolean $manage_database                      = true,
  Boolean $manage_firewall_entry                = true,
  Boolean $manage_repo                          = false,
  Boolean $manage_sd_service                    = false,
  Hash $plugins                                 = {},
  String $rpm_iteration                         = '1',
  String $root_url                              = '%(protocol)s://%(domain)s/',
  Array $sd_service_tags                        = ['metrics'],
  String $secret_key                            = 'inWSYLbKCoLko',
  Boolean $smtp_enable                          = false,
  String $smtp_from_address                     = 'admin@grafana.localhost',
  String $smtp_from_name                        = 'Grafana',
  String $smtp_host                             = 'localhost:25',
  String $version                               = '8.3.2',
) {
  $default_cfg = {
    server            => {
      domain    => $domain,
      protocol  => 'http',
      http_addr => $http_addr,
      root_url  => $root_url,
    },
    'auth.anonymous'  => {
      enabled  => true,
      org_name => $default_org,
      org_role => 'Viewer',
    },
    'auth.basic'      => {
      enabled => true,
    },
    'auth.proxy'      => {
      enabled         => false,
      header_name     => 'X-WEBAUTH-USER',
      header_property => 'username',
      auto_sign_up    => true,
    },
    event_publisher   => {
      enabled      => false,
      rabbitmq_url => '',
      exchange     => 'grafana_events',
    },
    'dashboards.json' => {
      enabled => false,
      path    => '/var/lib/grafana/dashboards',
    },
    database          => {
      host     => "${db_host}:${db_port}",
      name     => $db_name,
      password => $db_password,
      path     => $db_path,
      type     => $db_type,
      user     => $db_user,
    },
    log               => {
      mode       => $logmode,
      buffer_len => $log_buffer_length,
      level      => $log_level,
    },
    'log.console'     => {
      level => '',
    },
    'log.file'        => {
      log_rotate      => $log_rotate,
      max_lines       => $log_max_lines,
      max_lines_shift => $log_max_lines_shift,
      daily_rotate    => $log_daily_rotate,
      max_days        => $log_max_days,
    },
    security          => {
      admin_user                  => $admin_user,
      admin_password              => $admin_password,
      secret_key                  => $secret_key,
      login_remember_days         => $login_remember_days,
      cookie_username             => $cookie_username,
      cookie_remember_name        => $cookie_remember_name,
      disable_gravatar            => $disable_gravatar,
      data_source_proxy_whitelist => $data_source_proxy_whitelist,
    },
    smtp              => {
      enabled      => $smtp_enable,
      from_address => $smtp_from_address,
      from_name    => $smtp_from_name,
      host         => $smtp_host,
    },
    users             => {
      allow_sign_up        => $allow_sign_up,
      allow_org_create     => $allow_org_create,
      auto_assign_org      => $auto_assign_org,
      auth_assign_org_role => $auth_assign_org_role,
    },
  }

  $cfg = $default_cfg + $extra_cfg

  class { 'grafana':
    cfg                 => $cfg,
    install_method      => $install_method,
    manage_package_repo => $manage_repo,
    rpm_iteration       => $rpm_iteration,
    version             => $version,
  }

  if $manage_database {
    case $db_type {
      'mysql': {
        profiles::database::mysql::db { $db_name:
          grant    => $db_grant,
          host     => $db_host,
          password => $db_password,
          user     => $db_user,
        }
        Mysql::Db[$db_name] -> Service['grafana']
        Service['mysqld'] -> Service['grafana']
      }
      'postgres': {
        profiles::database::postgresql::db { $db_name:
          grant    => $db_grant,
          password => $db_password,
          user     => $db_user,
        }
        Profiles::Database::Postgresql::Db[$db_name] -> Service['grafana']
        Service['postgresqld'] -> Service['grafana']
      }
      default: { fail("${db_type} is not supported") }
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'grafana':
      checks => [
        {
          http     => "http://${http_addr}:3000",
          interval => '10s'
        },
      ],
      port   => 3000,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow node grafana':
      port => 3000,
    }
  }

  $defaults = {
    grafana_url      => 'http://localhost:3000',
    grafana_user     => $admin_user,
    grafana_password => $admin_password,
  }
  create_resources(::profiles::metrics::grafana::dashboard, $dashboards, $defaults)

  create_resources(::profiles::metrics::grafana::datasource, $datasources, $defaults)
  create_resources(::profiles::metrics::grafana::plugin, $plugins)
}
