# This class can be used install mysql
#
# @example when declaring the mysql class
#  class { '::profiles::database::mysql': }
#
# @param databases     Set of Databases to create.
# @param root_password Root password.
class profiles::database::mysql (
  Hash $databases = {},
  String $root_password = 'secret',
) {
  class { '::mysql::server':
    root_password => $root_password,
  }
  class { '::mysql::server::account_security': }
  create_resources(mysql::db, $databases)

  class { '::mysql::client': }

  profiles::bootstrap::firewall::entry { '200 allow mysql':
    port => 3306,
  }
}
