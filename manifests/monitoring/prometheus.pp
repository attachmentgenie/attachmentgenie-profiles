# This class can be used install user prometheus properties
#
# @example when declaring the prometheus class
#  class { '::profiles::monitoring::prometheus': }
#
# @param client                   Install node exporter
# @param node_exporter_collectors Metrics to collect.
# @param node_exporter_version    Version to install
# @param scrape_configs           Which nodes to monitor
# @param server                   Install Server.
# @param prometheus_version       Version to install
class profiles::monitoring::prometheus (
  Boolean $client = true,
  Array $node_exporter_collectors =  ['diskstats','filesystem','loadavg','meminfo','netdev','stat','tcpstat','time','vmstat'],
  String $node_exporter_version = '0.15.2',
  Array $scrape_configs = [ {
    'job_name'=>'prometheus',
    'scrape_interval'=> '30s',
    'scrape_timeout'=>'30s',
    'static_configs'=> [{'targets'=>['localhost:9090'], 'labels'=> { 'alias'=>'Prometheus'}}]
  } ],
  Boolean $server = false,
  String $prometheus_version = '2.4.2',
) {
  if $client {
    class { '::prometheus::node_exporter':
      collectors => $node_exporter_collectors,
      version    => $node_exporter_version,
    }
  }
  if $server {
    class { '::prometheus':
      scrape_configs => $scrape_configs,
      version        => $prometheus_version,
    }
  }
}
