# This class can be used install statsd properties
#
# @example when declaring the statsd class
#  class { '::profiles::statsd': }
#
# @param address  (String) adress to bind to.
# @param backends (Array) Which backends to configure.
# @param flush_interval (Interger) # of ms to aggregate date before sending.
# @param graphite_host (String) Graphite address.
# @param graphite_port (Integer) graphite port.
# @param influxdb_database (String) Database name
# @param influxdb_flush (Boolean) flush datapoints
# @param influxdb_host (String) influxdb address.
# @param influxdb_password (String) db password.
# @param influxdb_port (Integer) influxdb port.
# @param influxdb_username (String) db username.
# @param influxdb_version (String) db version.
# @param install_method (String) install method.
# @param mgmt_address (String) Address to bind to.
# @param port (String) Port to bind to.
class profiles::statsd (
  $address           = '127.0.0.1',
  $backends          = [ './backends/graphite' ],
  $flush_interval    = 60000,
  $graphite_host     = '127.0.0.1',
  $graphite_port     = 2003,
  $influxdb_database = 'statsd',
  $influxdb_flush    = true,
  $influxdb_host     = '127.0.0.1',
  $influxdb_password = 'root',
  $influxdb_port     = 8086,
  $influxdb_username = 'root',
  $influxdb_version  = '1.2',
  $install_method    = 'yum',
  $mgmt_address      = '127.0.0.1',
  $port              = 8125,
) {
  validate_array(
    $backends,
  )
  validate_integer([
    $flush_interval,
    $graphite_port,
    $port,
  ])
  validate_string(
    $address,
    $graphite_host,
    $install_method,
    $mgmt_address,
  )

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