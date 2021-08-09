# This class can be used to create pgsql databases
#
# @example when declaring the postgresql class
#  class { '::profiles::database::postgresql::db': }
#
define profiles::database::postgresql::db (
  String $password,
  String $user,
  Boolean $encrypted = true,
  String $grant = 'ALL',
) {

  if $encrypted {
    $_password = postgresql::postgresql_password($user, $password)
  } else {
    $_password = $password
  }
  ::postgresql::server::db { $title:
    user     => $user,
    password => $_password,
    grant    => $grant,
  }
}