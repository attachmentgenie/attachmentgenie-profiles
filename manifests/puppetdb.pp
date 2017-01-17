# This class can be used install user puppetdb properties
#
# @example when declaring the apache class
#  class { '::profiles::puppetdb': }
#
# @param database_host (String) Db host.
# @param database_password (String) Db password.
# @param listen_address (String) interface to bind to.
# @param manage_dbserver (Boolean) Manage postgresql backend.
# @param manage_firewall (Boolean) Manage firewall entries.
# @param manage_pg_repo (Boolean) Manage postgresql repo.
# @param postgres_version (String) Postgresql version.
# @param ssl_listen_address (String) interface to bind ssl to.
class profiles::puppetdb (
  $database_host      = 'localhost',
  $database_password  = 'puppetdb',
  $listen_address     = '0.0.0.0',
  $manage_dbserver    = true,
  $manage_firewall    = false,
  $manage_pg_repo     = false,
  $postgres_version   = '9.5',
  $ssl_listen_address = '0.0.0.0',
) {
  validate_bool(
    $manage_dbserver,
    $manage_firewall,
    $manage_pg_repo,
  )
  validate_string(
    $database_host,
    $listen_address,
    $ssl_listen_address,
  )
  class { '::puppetdb':
    database_host       => $database_host,
    database_password   => $database_password,
    listen_address      => $listen_address,
    manage_dbserver     => $manage_dbserver,
    manage_firewall     => $manage_firewall,
    manage_package_repo => $manage_pg_repo,
    postgres_version    => $postgres_version,
    ssl_listen_address  => $ssl_listen_address,
  }
}
