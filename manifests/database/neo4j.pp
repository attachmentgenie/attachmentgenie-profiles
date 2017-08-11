# This class can be used install neo4j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::database::neo4j': }
#
# @param install_method How to install.
# @param manage_repo    Manage repo.
# @param version        Version to install.
class profiles::database::neo4j (
  String $install_method = 'package',
  Boolean $manage_repo = false,
  String $version = 'installed'
) {
  class { '::neo4j' :
    install_method => $install_method,
    manage_repo    => $manage_repo,
    version        => $version,
  }
}
