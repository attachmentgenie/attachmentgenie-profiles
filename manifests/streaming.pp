# This class can be used install streaming and zookeeper.
#
# @example when declaring the streaming class
#  class { '::profiles::streaming': }
#
# @param flink     Manage flink on this node.
# @param kafka     Manage kafka on this node.
# @param zookeeper Manage zookeeper on this node.
class profiles::streaming (
  Boolean $flink = false,
  Boolean $kafka = false,
  Boolean $zookeeper = false,
) {
  if $flink {
    class { '::profiles::streaming::flink':}
  }
  if $kafka {
    class {'::profiles::streaming::kafka':}
    if $zookeeper {
      Class['zookeeper::service'] -> Class['kafka::broker::service']
    }
  }
  if $zookeeper {
    class { '::profiles::streaming::zookeeper':}
  }
}
