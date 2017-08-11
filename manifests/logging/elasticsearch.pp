# This class can be used install elasticsearch components.
#
# @example when declaring the elasticsearch class
#  class { '::profiles::logging::elasticsearch': }
#
# @param instances    ES instances to start.
# @param manage_repo  Let profile install java.
# @param repo_version Version family to install.
class profiles::logging::elasticsearch (
  Hash $instances = { "${::fqdn}" => {} },
  Boolean $manage_repo = false,
  String $repo_version = '5.x',
) {
  class { '::elasticsearch':
    java_install      => false,
    manage_repo       => $manage_repo,
    repo_version      => $repo_version,
    restart_on_change => true
  }
  create_resources('elasticsearch::instance', $instances)
}
