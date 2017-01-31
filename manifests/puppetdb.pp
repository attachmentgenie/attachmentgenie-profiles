# This class can be used install user puppetdb properties
#
# @example when declaring the apache class
#  class { '::profiles::puppetdb': }
#
# @param database_host (String) Db host.
# @param database_password (String) Db password.
# @param listen_address (String) interface to bind to.
# @param manage_firewall (Boolean) Manage firewall entries.
# @param ssl_listen_address (String) interface to bind ssl to.
class profiles::puppetdb (
  $database_host      = 'localhost',
  $database_password  = 'puppetdb',
  $listen_address     = '0.0.0.0',
  $manage_firewall    = false,
  $ssl_listen_address = '0.0.0.0',
) {
  validate_bool(
    $manage_firewall,
  )
  validate_string(
    $database_host,
    $database_password,
    $listen_address,
    $ssl_listen_address,
  )
  class { '::puppetdb::server':
    database_host      => $database_host,
    database_password  => $database_password,
    listen_address     => $listen_address,
    manage_firewall    => $manage_firewall,
    ssl_listen_address => $ssl_listen_address,
  }
}
