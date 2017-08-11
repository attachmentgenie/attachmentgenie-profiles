# This class can be used install metrics.
#
# @example when declaring the metrics class
#  class { '::profiles::database::metrics': }
#
# @param influxdb   Manage influxdb on this node.
# @param mongodb    Manage mongodb on this node.
# @param mysql      Manage mysql on this node.
# @param neo4j      Manage neo4j on this node.
# @param postgresql Manage postgresql on this node.
class profiles::database (
  Boolean $influxdb = false,
  Boolean $mongodb = false,
  Boolean $mysql = false,
  Boolean $neo4j = false,
  Boolean $postgresql = false,
) {
  if $influxdb {
    class { '::profiles::database::influxdb':}
  }
  if $mongodb {
    class { '::profiles::database::mongodb':}
  }
  if $mysql {
    class { '::profiles::database::mysql':}
  }
  if $neo4j {
    class { '::profiles::database::neo4j': }
  }
  if $postgresql {
    class { '::profiles::database::postgresql':}
  }
}
