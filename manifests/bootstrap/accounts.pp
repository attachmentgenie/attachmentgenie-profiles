# This class can be used install user accounts properties
#
# @example when declaring the apache class
#  class { '::profiles::bootstrap::accounts': }
#
# @param accounts   User accounts to manage.
# @param groups     Groups to manage.
# @param sudo_confs Sudo rules to manage.
class profiles::bootstrap::accounts (
  Hash $accounts   = {},
  Hash $groups     = {},
  Hash $sudo_confs = {},
) {
  if length($accounts) > 0 {
    create_resources( 'accounts::user', $accounts)
  }

  if length($groups) > 0 {
    create_resources('group', $groups)
  }

  if (length($accounts) > 0) and (length($groups) > 0)  {
    Group<||> -> User<||>
  }

  if length($sudo_confs) > 0 {
    class { '::sudo':
      config_file_replace => false,
      purge               => false,
    }
    create_resources( 'sudo::conf', $sudo_confs)
  }
}
