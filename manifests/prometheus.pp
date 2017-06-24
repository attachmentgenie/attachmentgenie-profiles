# This class can be used install user prometheus properties
#
# @example when declaring the prometheus class
#  class { '::profiles::prometheus': }
#
# @param client (Boolean) Install node exporter
# @param node_exporter_version (String) Version to install
# @param scrape_configs (array) which nodes to monitor
# @param server (Boolean) Install Server.
# @param prometheus_version (String) Version to install
class profiles::prometheus (
  $client                = true,
  $node_exporter_version = '0.14.0',
  $scrape_configs        = [ {
      'job_name'=>'prometheus',
      'scrape_interval'=> '30s',
      'scrape_timeout'=>'30s',
      'static_configs'=> [{'targets'=>['localhost:9090'], 'labels'=> { 'alias'=>'Prometheus'}}]
    } ],
  $server                = false,
  $prometheus_version    = '1.7.1',
) {
  validate_array(
    $scrape_configs,
  )
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
      scrape_configs => $scrape_configs,
      version        => $prometheus_version,
    }
  }
}