# This class can be used install elasticsearch components.
#
# @example when declaring the elasticsearch class
#  class { '::profiles::elasticsearch': }
#
# @param instances (Hash) ES instances to start.
# @param manage_repo (Boolean) Let profile install java.
# @param repo_version (String) Version family to install.
class profiles::elasticsearch (
  $instances    = { "${::fqdn}" => {} },
  $manage_repo  = false,
  $repo_version = '2.x',
) {
  validate_bool(
    $manage_repo,
  )
  validate_string(
    $repo_version,
  )
  class { '::elasticsearch':
    java_install      => false,
    manage_repo       => $manage_repo,
    repo_version      => $repo_version,
    restart_on_change => true
  }
  create_resources('elasticsearch::instance', $instances)
}