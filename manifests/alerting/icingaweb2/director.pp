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
  String $db_name      = 'director',
  String $db_username  = 'director',
  String $db_password  = 'director',
  String $db_host      = 'localhost',
  String $api_user     = $::profiles::alerting::icingaweb2::api_user,
  String $api_password = $::profiles::alerting::icingaweb2::api_password,
  String $api_host     = 'localhost',
  String $endpoint     = $::fqdn,
) inherits profiles::alerting::icingaweb2 {

  class {'icingaweb2::module::director':
    db_name       => $db_name,
    db_username   => $db_username,
    db_password   => $db_password,
    db_host       => $db_host,
    db_type       => 'pgsql',
    db_port       => 5432,
    api_username  => $api_user,
    api_password  => $api_password,
    api_host      => $api_host,
    import_schema => true,
    kickstart     => true,
    endpoint      => $endpoint,
    require       => [
      Package['git'],
      Postgresql::Server::Db[$db_name],
    ],
  }
}
