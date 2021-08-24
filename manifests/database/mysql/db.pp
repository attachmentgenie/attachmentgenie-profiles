# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::database::mysql::db { 'namevar': }
define profiles::database::mysql::db (
  String $password,
  String $user,
  String $grant = 'ALL',
  Stdlib::Host $host = 'localhost',
) {
  mysql::db { $title:
    grant    => $grant,
    host     => $host,
    password => $password,
    user     => $user,
  }
}
