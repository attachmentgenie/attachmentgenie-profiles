# This class is used to setup the director module on icingaweb2.
#
# It manages all the needed dependencies for setting up the director module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::director': }
#
# @param db_name      Database name for the director db
# @param db_username  User for the database
# @param db_password  The password for the user
# @param db_host      The host where the database lives
# @param api_user     User for connecting to the api
# @param api_password The api user's password
# @param api_host     The host where the api lives
# @param endpoint     Endpoint to bind to
class profiles::alerting::icingaweb2::director (
  String $api_user = $::profiles::alerting::icingaweb2::api_user,
  String $api_password = $::profiles::alerting::icingaweb2::api_password,
  String $api_host = 'localhost',
  String $database_grant = 'all',
  String $database_host = 'localhost',
  String $database_name = 'director',
  String $database_username = 'director',
  String $database_password = 'director',
  String $endpoint = $::fqdn,
  Boolean $daemon_enable = true,
  Boolean $manage_database = true,
  Optional[String] $version = 'v1.8.0',
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::director':
    db_name       => $database_name,
    db_username   => $database_username,
    db_password   => $database_password,
    db_host       => $database_host,
    db_type       => 'pgsql',
    db_port       => 5432,
    git_revision  => $version,
    api_username  => $api_user,
    api_password  => $api_password,
    api_host      => $api_host,
    import_schema => true,
    kickstart     => true,
    endpoint      => $endpoint,
    require       => [
      Package['git'],
      Postgresql::Server::Db[$database_name],
    ],
  }

  if $daemon_enable {
    user { 'icingadirector':
      home       => '/var/lib/icingadirector',
      groups     => ['icingaweb2'],
      managehome => true,
      shell      => '/bin/false',
    }
    -> systemd::unit_file { 'icinga-director.service':
      source => "puppet:///modules/${module_name}/alerting/icingaweb2/icinga-director.service",
    }
    ~> service {'icinga-director':
      ensure => 'running',
    }
  }

  if $manage_database {
    profiles::database::postgresql::db { $database_name:
      grant    => $database_grant,
      password => $database_password,
      user     => $database_username,
    }
  }
}
