# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::database::mysql::user { 'namevar': }
define profiles::database::mysql::user (
  Array $grants,
  String $password,
  String $table,
  Enum['absent','present'] $ensure = 'present',
  String $host = 'localhost',
) {
  mysql_user { "${title}@${host}":
    ensure        => $ensure,
    password_hash => mysql::password($password),
  }
  -> mysql_grant { "${title}@${host}/${table}":
    ensure     => $ensure,
    privileges => $grants,
    user       => "${title}@${host}",
    table      => $table,
  }
}
