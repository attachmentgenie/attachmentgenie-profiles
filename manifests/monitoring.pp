# This class can be used install monitoring components
#
# @example when declaring the monitroin class
#  class { '::profiles::monitoring': }
#
# @param carbon_relay Manage carbon_relay on this node.
# @param collectd     Manage collectd on this node.
# @param logstash     Manage logstash on this node.
# @param statsd       Manage statsd on this node.
class profiles::monitoring (
  Boolean $carbon_relay = false,
  Boolean $collectd = false,
  Boolean $logstash = false,
  Boolean $statsd = false,
) {
  if $carbon_relay {
    class { '::profiles::monitoring::carbon_relay': }
  }
  if $collectd {
    class { '::profiles::monitoring::collectd': }
  }
  if $logstash {
    class { '::profiles::monitoring::logstash': }
  }
  if $statsd {
    class { '::profiles::monitoring::statsd': }
  }
}
