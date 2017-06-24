# == Class profiles::graphite_web
#
# This class can be used to install graphite_web, a python graphite web frontend.
#
# === Examples
#
# class { 'profiles::graphite_web': }
#
# === Parameters
#
# @param carbon_caches (Hash) List of cache instances.
# @param database_engine (String) Type of database.
# @param databases (Hash) Containing database connection details
# @param debug (Boolean) Switch for debugging graphite
# @param memcached_enabled (Boolean) Use memcache as caching layer
#
class profiles::graphite_web (
  $carbon_caches    = {},
  $database_engine  = 'postgresql',
  $databases        = { default =>
    { name     => 'graphite',
      engine   => 'django.db.backends.postgresql_psycopg2',
      user     => 'graphite',
      password => 'secret',
      host     => '127.0.0.1'
    }
  },
  $debug             = 'False',
  $memcached_enabled = true
) {

  class { '::graphite_web':
    carbon_caches          => $carbon_caches,
    config_debug           => $debug,
    config_database_engine => $database_engine,
    config_databases       => $databases,
    memcached_enabled      => $memcached_enabled,
  }
}
