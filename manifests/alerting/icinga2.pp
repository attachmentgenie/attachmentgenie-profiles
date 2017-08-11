# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::alerting::icinga2': }
#
# @param database_name     Db name
# @param database_password Db password.
# @param database_user     Db user.
# @param manage_repo       Manage icinga repository.
class profiles::alerting::icinga2 (
  String $database_name     = 'icinga2',
  String $database_password = 'icinga2',
  String $database_user     = 'icinga2',
  Boolean $manage_repo       = false,
) {
  class { '::icinga2':
    manage_repo => $manage_repo,
  }
  class{ '::icinga2::feature::idomysql':
    database      => $database_name,
    import_schema => true,
    password      => $database_password,
    user          => $database_user,
  }
}
