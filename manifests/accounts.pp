# This class can be used install user accounts properties
#
# @example when declaring the apache class
#  class { '::profiles::accounts': }
#
# @param accounts (Hash)) User accounts to manage.
class profiles::accounts (
  $accounts = {},
) {
  validate_hash(
    $accounts,
  )
  create_resources( 'accounts::user', $accounts)
}