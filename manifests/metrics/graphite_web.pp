# == Class profiles::metrics::graphite_web
#
# This class can be used to install graphite_web, a python graphite web frontend.
#
# === Examples
#
# class { 'profiles::metrics::graphite_web': }
#
# === Parameters
#
# @param carbon_caches     List of cache instances.
# @param database_engine   Type of database.
# @param databases         Containing database connection details
# @param debug             Switch for debugging graphite
# @param memcached_enabled Use memcache as caching layer
#
class profiles::metrics::graphite_web (
  Hash $carbon_caches = {},
  String $database_engine = 'postgresql',
  Hash $databases = { default =>
    { name     => 'graphite',
      engine   => 'django.db.backends.postgresql_psycopg2',
      user     => 'graphite',
      password => 'secret',
      host     => '127.0.0.1'
    }
  },
  String $debug = 'False',
  Boolean $memcached_enabled = true
) {

  class { '::graphite_web':
    carbon_caches          => $carbon_caches,
    config_debug           => $debug,
    config_database_engine => $database_engine,
    config_databases       => $databases,
    memcached_enabled      => $memcached_enabled,
  }
}
