# This class can be used install elasticsearch components.
#
# @example when declaring the elasticsearch class
#  class { '::profiles::logging::elasticsearch': }
#
# @param instances    ES instances to start.
# @param manage_repo  Let profile install java.
# @param repo_version Version family to install.
class profiles::logging::elasticsearch (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_repo = false,
  String $repo_version = '7.x',
  String $sd_service_name = 'postgresql',
  Array $sd_service_tags = [],
) {
  class { 'elasticsearch':
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
    restart_on_change => true,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow allow elasticsearch':
      port => [9200,9300],
    }
  }
}
