# This class can be used to setup icinga2_web.
#
# @example when declaring the node role
#  class { '::profiles::icinga2_web': }
#
# @param database_name (String) db name
# @param database_password (String) db password.
# @param database_user (String) db user.
# @param initialize (Boolean) Setup basic icinga
# @param install_method (String) How to install icinga web.
# @param manage_repo (Boolean) Manage icinga2 web repos.
# @param manage_vhost (Boolean) Manage web vhost.
class profiles::icinga2_web (
  $database_name     = 'icingaweb2',
  $database_password = 'icingaweb2',
  $database_user     = 'icingaweb2',
  $ido_db_name       = 'icinga2',
  $ido_db_password   = 'icinga2',
  $ido_db_user       = 'icinga2',
  $initialize        = true,
  $install_method    = 'package',
  $manage_repo       = false,
  $manage_vhost      = false,
) {
  validate_bool(
    $initialize,
    $manage_repo,
    $manage_vhost
  )
  validate_string(
    $database_name,
    $database_password,
    $database_user,
    $ido_db_name,
    $ido_db_password,
    $ido_db_user,
    $install_method
  )
  class { '::icingaweb2':
    initialize          => $initialize,
    install_method      => $install_method,
    manage_apache_vhost => $manage_vhost,
    manage_repo         => $manage_repo,
    ido_db_name         => $ido_db_name,
    ido_db_pass         => $ido_db_password,
    ido_db_user         => $ido_db_user,
    web_db_name         => $database_name,
    web_db_pass         => $database_password,
    web_db_user         => $database_user,
  }
}
