# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::kibana': }
#
# @param manage_repo (Boolean) Let profile install java.
# @param package_repo_version (String) package repo family to install from.
# @param version (String) Version to install.
class profiles::kibana (
  $manage_repo          = false,
  $package_repo_version = '4.6',
  $version              = present,
) {
  validate_bool(
    $manage_repo,
  )
  validate_string(
    $version,
  )
  class { '::kibana4':
    manage_repo          => $manage_repo,
    package_repo_version => $package_repo_version,
    version              => $version,
  }
}