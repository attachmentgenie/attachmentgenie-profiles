# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::database::mysql::user { 'namevar': }
define profiles::database::mysql::user (
  String $dbname,
  Array $grants,
  String $password,
  Enum['absent','present'] $ensure = 'present',
  String $host = 'localhost',
) {
  $_table = "${dbname}.*"

  mysql_user { "${title}@${host}":
    ensure        => $ensure,
    password_hash => mysql::password($password),
  }
  -> mysql_grant { "${title}@${host}/${_table}":
    ensure     => $ensure,
    privileges => $grants,
    user       => "${title}@${host}",
    table      => $_table,
  }
}
