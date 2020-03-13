# This class can be used to create pgsql databases
#
# @example when declaring the postgresql class
#  class { '::profiles::database::postgresql::db': }
#
define profiles::database::postgresql::db (
  String $user,
  String $password,
  String $grant = 'ALL',
) {

  ::postgresql::server::db { $title:
    user     => $user,
    password => postgresql_password($user, $password),
    grant    => $grant,
  }
}