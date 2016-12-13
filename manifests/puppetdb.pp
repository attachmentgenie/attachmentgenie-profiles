# This class can be used install user puppetdb properties
#
# @example when declaring the apache class
#  class { '::profiles::puppetdb': }
#
# @param listen_address (String) interface to bind to.
# @param manage_dbserver (Boolean) Manage postgresql backend.
# @param manage_firewall (Boolean) Manage firewall entries.
# @param manage_pg_repo (Boolean) Manage postgresql repo.
# @param ssl_listen_address (String) interface to bind ssl to.
class profiles::puppetdb (
  $listen_address     = '0.0.0.0',
  $manage_dbserver    = true,
  $manage_firewall    = false,
  $manage_pg_repo     = false,
  $ssl_listen_address = '0.0.0.0',
) {
  class { '::puppetdb':
    listen_address     => $listen_address,
    manage_dbserver    => $manage_dbserver,
    manage_firewall    => $manage_firewall,
    ssl_listen_address => $ssl_listen_address,
  }
}