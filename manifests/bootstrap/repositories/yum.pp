# @summary Manage additional repositories
#
# Setup additional package repostitories and the config that governes it.
#
# @example
#   include profiles::bootstrap::repositories::apt
#
#
# @param repositories    Repositories to configure
class profiles::bootstrap::repositories::yum (
  Hash $repositories       = {},
) {
  $yum_defaults = {
    enabled  => 1,
    gpgcheck => 1,
  }
  create_resources( 'yumrepo', $repositories, $yum_defaults )
}
