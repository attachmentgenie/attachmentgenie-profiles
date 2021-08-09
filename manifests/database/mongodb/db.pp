# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::database::mongodb::db { 'namevar': }
define profiles::database::mongodb::db (
  String           $user,
  Optional[String] $password_hash = undef,
  Optional[String] $password      = undef,
) {
  mongodb::db { $title:
    user          => $user,
    password_hash => $password_hash,
    password      => $password,
  }
}
