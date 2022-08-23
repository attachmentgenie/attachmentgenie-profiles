# This class can be used install user prometheus properties
#
# @example when declaring the prometheus class
#  class { '::profiles::monitoring::prometheus': }
#
class profiles::monitoring::prometheus (
  Hash $alerts = {
    'node_exporter' => {
      'groups' => [
        {
          'name'  => 'alert.rules',
          'rules' => [
            {
              'alert'       => 'InstanceDown',
              'expr'        => 'up == 0',
              'for'         => '5m',
              'labels'      => { 'severity' => 'page' },
              'annotations' => {
                'summary'     => 'Instance {{ $labels.instance }} down',
                'description' => 
                  '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.',
              },
            },
          ],
        },
      ],
    },
  },
  Array $alertmanager_configs = [
    {
      'static_configs' => [{ 'targets' => ['localhost:9093'] }],
    },
  ],
  Boolean $blackbox = false,
  Boolean $client = true,
  Stdlib::Absolutepath $data_path = '/var/lib/prometheus',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $graphite_exporters = false,
  Enum['url', 'package', 'none'] $install_method = 'none',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'prometheus',
  Boolean $pushgateway = false,
  Array $scrape_configs = [{
      'job_name'        => 'prometheus',
      'scrape_interval' => '10s',
      'scrape_timeout'  => '10s',
      'static_configs'  => [
        {
          'targets' => ['localhost:9090'],
        }
      ],
  }],
  Array $sd_service_tags = ['metrics'],
  Boolean $server = false,
  String $prometheus_version = '2.31.1',
) {
  if $server {
    class { 'prometheus':
      alertmanagers_config           => $alertmanager_configs,
      extra_alerts                   => $alerts,
      include_default_scrape_configs => false,
      localstorage                   => $data_path,
      manage_prometheus_server       => true,
      scrape_configs                 => $scrape_configs,
      version                        => $prometheus_version,
    }

    if $manage_disk {
      ::profiles::bootstrap::disk::mount { 'prometheus':
        device    => $device,
        mountpath => $data_path,
        before    => File[$data_path],
      }
    }

    if $manage_sd_service {
      ::profiles::orchestration::consul::service { $sd_service_name:
        checks => [
          {
            http     => 'http://localhost:9090',
            interval => '10s'
          },
        ],
        port   => 9090,
        tags   => $sd_service_tags,
      }
    }

    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '200 allow prometheus':
        port => 9090,
      }
    }

    if $blackbox {
      class { 'profiles::monitoring::prometheus::blackbox_exporter':
        manage_firewall_entry => $manage_firewall_entry,
        manage_sd_service     => $manage_sd_service,
      }
    }

    if $pushgateway {
      class { 'profiles::monitoring::prometheus::pushgateway':
        manage_firewall_entry => $manage_firewall_entry,
        manage_sd_service     => $manage_sd_service,
      }
    }

    if $graphite_exporters {
      class { 'profiles::monitoring::prometheus::graphite_exporter':
        manage_firewall_entry => $manage_firewall_entry,
        manage_sd_service     => $manage_sd_service,
      }
      class { 'profiles::monitoring::prometheus::statsd_exporter':
        manage_firewall_entry => $manage_firewall_entry,
        manage_sd_service     => $manage_sd_service,
      }
    }
  }
  # ordering matters => https://github.com/voxpupuli/puppet-prometheus/issues/208
  if $client {
    if !$server and !$manage_disk {
      file { $data_path:
        ensure => 'directory',
        mode   => '0755',
      }
    }
    class { 'profiles::monitoring::prometheus::node_exporter':
      manage_firewall_entry => $manage_firewall_entry,
      manage_sd_service     => $manage_sd_service,
    }
  }
}
