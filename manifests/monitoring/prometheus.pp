# This class can be used install user prometheus properties
#
# @example when declaring the prometheus class
#  class { '::profiles::monitoring::prometheus': }
#
# @param client                   Install node exporter
# @param install_method           The install method to use
# @param node_exporter_collectors Metrics to collect.
# @param node_exporter_version    Version to install
# @param scrape_configs           Which nodes to monitor
# @param server                   Install Server.
# @param prometheus_version       Version to install
class profiles::monitoring::prometheus (
  Boolean $client = true,
  Stdlib::Absolutepath $data_path = '/var/lib/prometheus',
  Optional[Stdlib::Absolutepath] $device = undef,
  Enum['url', 'package', 'none'] $install_method = 'none',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $node_exporter_collectors =  ['diskstats','filesystem','loadavg','meminfo','netdev','stat','tcpstat','time','vmstat'],
  String $node_exporter_version = '0.18.1',
  Array $scrape_configs = [ {
    'job_name'        => 'prometheus',
    'scrape_interval' => '10s',
    'scrape_timeout'  => '10s',
    'static_configs'  => [
      {
        'targets' => ['localhost:9090'],
        'labels'  => {'alias' => 'Prometheus'}
      }
    ],
  } ],
  Boolean $server = false,
  String $prometheus_version = '2.11.1',
) {
  if $server {
    class { '::prometheus':
      alerts                   => {
        'groups' => [
          {
            'name'  => 'alert.rules',
            'rules' => [
              {
                'alert'       => 'InstanceDown',
                'expr'        => 'up == 0',
                'for'         => '5m',
                'labels'      => {'severity' => 'page'},
                'annotations' => {
                  'summary'     => 'Instance {{ $labels.instance }} down',
                  'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
                },
              },
            ],
          },
        ],
      },
      alertmanagers_config     => [
        {
          'static_configs' => [{'targets' => ['localhost:9093']}],
        },
      ],
      localstorage             => $data_path,
      manage_prometheus_server => true,
      scrape_configs           => $scrape_configs,
      version                  => $prometheus_version,
    }

    if $manage_disk {
      ::profiles::bootstrap::disk::mount {'prometheus':
        device    => $device,
        mountpath => $data_path,
        before    => File[$data_path],
      }
    }
  }

  # ordering matters => https://github.com/voxpupuli/puppet-prometheus/issues/208
  if $client {
    class { '::prometheus::node_exporter':
      version => $node_exporter_version,
    }

    if $manage_sd_service {
      ::profiles::orchestration::consul::service { 'node_exporter':
        checks => [
          {
            http     => 'http://localhost:9100',
            interval => '10s'
          }
        ],
        port   => 9100,
      }
    }

    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '200 allow node exporter':
        port => 9100,
      }
    }
  }
}
