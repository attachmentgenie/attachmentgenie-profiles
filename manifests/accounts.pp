# This class can be used install user accounts properties
#
# @example when declaring the apache class
#  class { '::profiles::accounts': }
#
# @param accounts (Hash) User accounts to manage.
# @param sudo_conf (Hash) Sudo rules to manage.
class profiles::accounts (
  $accounts   = {},
  $sudo_confs = {},
) {
  validate_hash(
    $accounts,
    $sudo_confs,
  )
  create_resources( 'accounts::user', $accounts)

  class { 'sudo':
    config_file_replace => false,
    purge               => false,
  }
  create_resources( 'sudo::conf', $sudo_confs)
}