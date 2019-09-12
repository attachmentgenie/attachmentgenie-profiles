# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::logging::kibana': }
#
# @param manage_repo  Let profile install java.
# @param repo_version Package repo family to install from.
# @param version      Version to install.
class profiles::logging::kibana (
  Boolean $manage_repo = false,
  String $repo_version = '7.x',
  String $version = present,
) {
  class { '::kibana':
    ensure       => $version,
    manage_repo  => $manage_repo,
  }
}
