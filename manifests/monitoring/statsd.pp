# This class can be used install statsd properties
#
# @example when declaring the statsd class
#  class { '::profiles::monitoring::statsd': }
#
# @param address           Adress to bind to.
# @param backends          Which backends to configure.
# @param flush_interval    # of ms to aggregate date before sending.
# @param graphite_host     Graphite address.
# @param graphite_port     Graphite port.
# @param influxdb_database Database name
# @param influxdb_flush    Flush datapoints
# @param influxdb_host     Influxdb address.
# @param influxdb_password DB password.
# @param influxdb_port     Influxdb port.
# @param influxdb_username DB username.
# @param influxdb_version  DB version.
# @param install_method    Install method.
# @param mgmt_address      Address to bind to.
# @param port              Port to bind to.
class profiles::monitoring::statsd (
  String $address           = '127.0.0.1',
  Array $backends           = [ './backends/graphite' ],
  Integer $flush_interval   = 60000,
  String $graphite_host     = '127.0.0.1',
  Integer $graphite_port    = 2003,
  String $influxdb_database = 'statsd',
  Boolean $influxdb_flush   = true,
  String $influxdb_host     = '127.0.0.1',
  String $influxdb_password = 'root',
  Integer $influxdb_port    = 8086,
  String $influxdb_username = 'root',
  String $influxdb_version  = '1.2',
  String $install_method    = 'yum',
  String $mgmt_address      = '127.0.0.1',
  Integer$port              = 8125,
) {
  class { '::statsd':
    address           => $address,
    backends          => $backends,
    flushInterval     => $flush_interval,
    graphiteHost      => $graphite_host,
    graphitePort      => $graphite_port,
    influxdb_database => $influxdb_database,
    influxdb_flush    => $influxdb_flush,
    influxdb_host     => $influxdb_host,
    influxdb_port     => $influxdb_port,
    influxdb_password => $influxdb_password,
    influxdb_username => $influxdb_username,
    influxdb_version  => $influxdb_version,
    mgmt_address      => $mgmt_address,
    package_provider  => $install_method,
    port              => $port,
  }
}
