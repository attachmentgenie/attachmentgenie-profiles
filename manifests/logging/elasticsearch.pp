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
  String $repo_version = '7.x',
) {
  class { '::elasticsearch':
    jvm_options       => [
      '#PrintGCDetails',
      '#PrintGCDateStamps',
      '#PrintTenuringDistribution',
      '#PrintGCApplicationStoppedTime',
      '#Xloggc',
      '#UseGCLogFileRotation',
      '#NumberOfGCLogFiles',
      '#GCLogFileSize',
      '#XX:UseConcMarkSweepGC',
    ],
    manage_repo       => $manage_repo,
    restart_on_change => true
  }
  create_resources('elasticsearch::instance', $instances)
}
