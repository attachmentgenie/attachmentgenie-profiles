# This class can be used to setup grafana.
#
# @example when declaring the node role
#  class { '::profiles::grafana': }
#
# @param allow_sign_up (Boolean) Allow users to sign up
# @param allow_org_create (Boolean) Allow organisations to be setup.
# @param auto_assign_org (Boolean) Automatically asign an organisation.
# @param auth_assign_org_role (String) Basic role.
# @param admin_password (String) Admin password.
# @param admin_user (String) Admin username
# @param cookie_username (String) Cookie name
# @param cookie_remember_name (String) Cookie remember setting
# @param data_source_proxy_whitelist (String) Proxy Whitelist.
# @param datasources (Hash) List of datasources.
# @param db_datadir (String) Directory to store data in.
# @param db_host (String) Db connection string
# @param db_name (String) DB name.
# @param db_password (String) DB password.
# @param db_path (String) DB path (sqlite only)
# @param db_type (String) DB type,
# @param db_user (String) DB user.
# @param disable_gravatar (Boolean) Disable gravatar downloadingg
# @param install_method (String) How to install grafana.
# @param log_buffer_length (Integer) Log bufeer length
# @param log_rotate (Boolean) Log rotation
# @param log_max_lines (Integer) Log max size
# @param log_max_lines_shift (Integer) Log max lines shift
# @param log_daily_rotate (Boolean) Rotate log daily.
# @param login_remember_days (Integer) Remember Login.
# @param log_level (String) Loglevel
# @param log_max_days (Integer) Keep logs for max days.
# @param logmode (String) Type of logging
# @param manage_repo (Boolean) Manage repo.
# @param rpm_iteration (String) RPM iteration to install.
# @param secret_key (String) Secret key.
# @param version (String) Version to install.
class profiles::grafana (
  $allow_sign_up               = true,
  $allow_org_create            = false,
  $auto_assign_org             = true,
  $auth_assign_org_role        = 'Viewer',
  $admin_password              = 'secret',
  $admin_user                  = 'admin',
  $cookie_username             = 'grafana_user',
  $cookie_remember_name        = 'grafana_remember',
  $data_source_proxy_whitelist = '',
  $datasources                 = {},
  $db_datadir                  = '/var/lib/pgsql/data',
  $db_host                     = '127.0.0.1:5432',
  $db_name                     = 'grafana',
  $db_password                 = '',
  $db_path                     = undef,
  $db_type                     = 'sqlite3',
  $db_user                     = '',
  $disable_gravatar            = false,
  $install_method              = 'repo',
  $log_buffer_length           = 10000,
  $log_rotate                  = true,
  $log_max_lines               = 1000000,
  $log_max_lines_shift         = 28,
  $log_daily_rotate            = true,
  $login_remember_days         = 7,
  $log_level                   = 'Info',
  $log_max_days                = 7,
  $logmode                     = 'console, file',
  $manage_repo                 = false,
  $rpm_iteration               = '1486989747',
  $secret_key                  = 'inWSYLbKCoLko',
  $version                     = '4.1.2',
) inherits profiles::grafana::params {
  validate_hash(
    $datasources,
  )

  class { '::grafana':
    cfg                 => {
      server            => {
        protocol  => 'http',
        http_addr => '127.0.0.1',
      },
      'auth.anonymous'  => {
        enabled  => true,
        org_name => 'ArthurJames',
        org_role => 'Viewer'
      },
      'auth.basic'      => {
        enabled => true
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
        host     => $db_host,
        name     => $db_name,
        password => $db_password,
        path     => $db_path,
        'type'   => $db_type,
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
      users             => {
        allow_sign_up        => $allow_sign_up,
        allow_org_create     => $allow_org_create,
        auto_assign_org      => $auto_assign_org,
        auth_assign_org_role => $auth_assign_org_role,
      },

    },
    install_method      => $install_method,
    manage_package_repo => $manage_repo,
    rpm_iteration       => $rpm_iteration,
    version             => $version,
  }
  $datasource_defaults = {
    grafana_url      => 'http://localhost:3000',
    grafana_user     => $admin_user,
    grafana_password => $admin_password,
  }
  create_resources(::profiles::grafana::datasource, $datasources, $datasource_defaults)
}
