# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::alerting::icinga2_web': }
#
# @param api_password          Api password.
# @param api_user              Api user.
# @param database_host         Db host.
# @param database_name         Db name.
# @param database_password     Db password.
# @param database_user         Db user.
# @param ido_database_host     Ido host.
# @param ido_database_name     Ido name.
# @param ido_database_password Ido password.
# @param ido_database_user     Ido user.
# @param manage_repo           Manage icinga2 web repos.
# @param modules               Include other icingaweb2 modules.
# @param roles                 Additional roles.
class profiles::alerting::icingaweb2 (
  String $api_password = 'icinga',
  String $api_user = 'root',
  String $api_endpoint = 'localhost',
  String $database_grant = 'all',
  String $database_host = '127.0.0.1',
  String $database_name = 'icingaweb2',
  String $database_password = 'icingaweb2',
  String $database_user = 'icingaweb2',
  String $ido_database_host = 'localhost',
  String $ido_database_name = 'icinga2',
  String $ido_database_password = 'icinga2',
  String $ido_database_user = 'icinga2',
  Boolean $manage_database = true,
  Boolean $manage_sd_service = false,
  Boolean $manage_repo = false,
  String $sd_service_name = 'icinga',
  Array $sd_service_tags = ['metrics'],
  Array $modules = [],
  Hash $roles = {},
  Hash $resources = {},
) {
  class { 'icingaweb2':
    manage_repo   => $manage_repo,
    module_path   => '/usr/share/icingaweb2/modules:/usr/share/icinga2-modules',
    import_schema => true,
    db_type       => 'pgsql',
    db_host       => $database_host,
    db_name       => $database_name,
    db_port       => 5432,
    db_username   => $database_user,
    db_password   => $database_password,
  }

  class { 'icingaweb2::module::monitoring':
    commandtransports => {
      icinga2 => {
        transport => 'api',
        username  => $api_user,
        password  => $api_password,
        host      => $api_endpoint,
      },
    },
    ido_type          => 'pgsql',
    ido_host          => $ido_database_host,
    ido_port          => 5432,
    ido_db_name       => $ido_database_name,
    ido_db_username   => $ido_database_user,
    ido_db_password   => $ido_database_password,
  }

  if ( $modules != []) {
    $modules.each | $module | {
      ensure_packages(['git'], { 'ensure' => 'present' })
      class { "::profiles::alerting::icingaweb2::${module}":; }
    }
  }

  if ( $roles!= {}) {
    create_resources( ::icingaweb2::config::role, $roles )
  }
  if ( $resources != {}) {
    create_resources( ::icingaweb2::config::resource, $resources )
  }

  if $manage_database {
    profiles::database::postgresql::db { $database_name:
      grant    => $database_grant,
      password => $database_password,
      user     => $database_user,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${facts['networking']['ip']}:80",
          interval => '10s'
        },
      ],
      port   => 80,
      tags   => $sd_service_tags,
    }
  }
}
