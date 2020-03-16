# This class can be used to create pgsql databases
#
# @example when declaring the postgresql class
#  class { '::profiles::database::postgresql::db': }
#
define profiles::database::postgresql::db (
  Boolean $encrypted = true,
  String $grant = 'ALL',
  String $password,
  String $user,
) {

  if $encrypted {
    $_password = postgresql_password($user, $password)
  } else {
    $_password = $password
  }
  ::postgresql::server::db { $title:
    user     => $user,
    password => $_password,
    grant    => $grant,
  }
}