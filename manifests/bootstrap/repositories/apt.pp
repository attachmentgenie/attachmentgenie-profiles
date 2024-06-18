# @summary Manage additional repositories
#
# Setup additional package repostitories and the config that governes it.
#
# @example
#   include profiles::bootstrap::repositories::apt
#
#
# @param repositories    Repositories to configure
class profiles::bootstrap::repositories::apt (
  Hash $apt_confs    = {},
  Hash $repositories = {},
) {
  $apt_conf_defaults = {
    ensure => present,
  }
  create_resources( 'apt::conf', $apt_confs, $apt_conf_defaults )

  $apt_repo_defaults = {
    ensure => present,
  }
  create_resources( 'apt::source', $repositories, $apt_repo_defaults )
}
