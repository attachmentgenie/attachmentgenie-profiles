# This class can be used install monitoring components
#
# @example when declaring the monitroin class
#  class { '::profiles::monitoring': }
#
# @param carbon_relay Manage carbon_relay on this node.
# @param collectd     Manage collectd on this node.
# @param icinga2      Manage icinga on this node.
# @param logstash     Manage logstash on this node.
# @param prometheus   Manage prometheus on this node.
# @param statsd       Manage statsd on this node.
class profiles::monitoring (
  Boolean $carbon_relay = false,
  Boolean $collectd = false,
  Boolean $icinga2= false,
  Boolean $logstash = false,
  Boolean $prometheus = false,
  Boolean $statsd = false,
) {
  if $carbon_relay {
    class { '::profiles::monitoring::carbon_relay': }
  }
  if $collectd {
    class { '::profiles::monitoring::collectd': }
  }
  if $icinga2 {
    class { '::profiles::monitoring::icinga2': }
  }
  if $logstash {
    class { '::profiles::monitoring::logstash': }
  }
  if $prometheus {
    class { '::profiles::monitoring::prometheus': }
  }
  if $statsd {
    class { '::profiles::monitoring::statsd': }
  }
}
