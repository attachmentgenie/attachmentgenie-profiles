# This class can be used install neo4j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::neo4j': }
#
# @param install_method (String) How to install.
# @param manage_repo [Boolean] Manage repo.
# @param version (String) Version to install.
class profiles::neo4j (
  $install_method = 'package',
  $manage_repo    = false,
  $version        = 'installed'
) {
  validate_bool(
    $manage_repo
  )
  validate_string(
    $install_method,
    $version
  )
  class { '::neo4j' :
    install_method => $install_method,
    manage_repo    => $manage_repo,
    version        => $version,
  }
}