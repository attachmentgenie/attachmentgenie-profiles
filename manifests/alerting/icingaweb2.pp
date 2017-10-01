# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::alerting::icinga2_web': }
#
# @param database_host     Db host.
# @param database_name     Db name.
# @param database_password Db password.
# @param database_user     Db user.
# @param manage_repo       Manage icinga2 web repos.
class profiles::alerting::icingaweb2 (
  String $database_host = '127.0.0.1',
  String $database_name = 'icingaweb2',
  String $database_password = 'icingaweb2',
  String $database_user = 'icingaweb2',
  Boolean $manage_repo = false,
) {
  class {'icingaweb2':
    manage_repo   => $manage_repo,
    import_schema => true,
    db_type       => 'pgsql',
    db_host       => $database_host,
    db_name       => $database_name,
    db_port       => 5432,
    db_username   => $database_user,
    db_password   => $database_password,
  }

  class {'icingaweb2::module::monitoring':
    commandtransports => {
      icinga2 => {
        transport => 'api',
        username  => 'root',
        password  => 'icinga',
      }
    },
    ido_type          => 'pgsql',
    ido_host          => 'localhost',
    ido_port          =>  5432,
    ido_db_name       => 'icinga2',
    ido_db_username   => 'icinga2',
    ido_db_password   => 'icinga2',
  }
}
