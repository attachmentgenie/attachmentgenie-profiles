# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::kibana': }
#
# @param manage_repo (Boolean) Let profile install java.
# @param repo_version (String) package repo family to install from.
# @param version (String) Version to install.
class profiles::kibana (
  $manage_repo  = false,
  $repo_version = '5.x',
  $version      = present,
) {
  validate_bool(
    $manage_repo,
  )
  validate_string(
    $repo_version,
    $version,
  )
  class { '::kibana':
    ensure       => $version,
    manage_repo  => $manage_repo,
    repo_version => $repo_version,
  }
}
