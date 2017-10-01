# This class can be used to setup icinga2.
#
# @example when declaring the node role
#  class { '::profiles::monitoring::icinga2': }
#
# @param database_host     Db host.
# @param database_name     Db name.
# @param database_password Db password.
# @param database_user     Db user.
# @param features          Enabled features.
# @param manage_repo       Manage icinga repository.
# @param plugins_package   Package with plugins to install.
class profiles::monitoring::icinga2 (
  String $database_host = '127.0.0.1',
  String $database_name = 'icinga2',
  String $database_password = 'icinga2',
  String $database_user = 'icinga2',
  Array $features = [ 'checker', 'mainlog', 'notification' ],
  Boolean $manage_repo = false,
  String $plugins_package = 'nagios-plugins-all',
) {
  package { 'nagios-plugins-all':
    name => $plugins_package,
  }

  class { '::icinga2':
    manage_repo => $manage_repo,
    features    => $features,
  }
  class{ 'icinga2::feature::idopgsql':
    host          => $database_host,
    user          => $database_user,
    password      => $database_password,
    database      => $database_name,
    import_schema => true,
  }

  class { '::icinga2::pki::ca': }
  class { '::icinga2::feature::api':
    accept_commands => true,
    pki             => 'none',
  }
}
