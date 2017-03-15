# This class can be used install user prometheus properties
#
# @example when declaring the apache class
#  class { '::profiles::prometheus': }
#
# @param client (Boolean) Install node exporter
# @param node_exporter_version (String) Version to install
# @param server (Boolean) Install Server.
# @param prometheus_version (String) Version to install
class profiles::prometheus (
  $client                = true,
  $node_exporter_version = '0.13.0',
  $server                = false,
  $prometheus_version    = '1.5.2',
) {
  validate_bool(
    $client,
    $server,
  )
  validate_string(
    $node_exporter_version,
    $prometheus_version,
  )
  if $client {
    class { '::prometheus::node_exporter':
      version => $node_exporter_version,
    }
  }
  if $server {
    class { '::prometheus':
      version => $prometheus_version,
    }
  }
}