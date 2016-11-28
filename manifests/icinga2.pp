# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::icinga2': }
#
# @param database_name (String) db name
# @param database_password (String) db password.
# @param database_user (String) db user.
# @param manage_repo (Boolean) Manage icinga repository.
class profiles::icinga2 (
  $database_name     = 'icinga2',
  $database_password = 'icinga2',
  $database_user     = 'icinga2',
  $manage_repo       = false,
) {
  class { '::icinga2':
    manage_repo => $manage_repo,
  }
  class{ '::icinga2::feature::idomysql':
    database      => $database_name,
    import_schema => true,
    password      => $database_password,
    user          => $database_user,
    require       => Mysql::Db['icinga2'],
  }
}
