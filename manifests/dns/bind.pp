# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::dns::bind': }
#
class profiles::dns::bind (
  Boolean $forward_consul = false,
) {
  class { '::dns': }

  if ($forward_consul) {
    dns::zone { 'consul':
      zonetype   => 'forward',
      forward    => 'only',
      forwarders => ['127.0.0.1 port 8600'],
    }
  }
}
