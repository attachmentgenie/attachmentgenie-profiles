# This class can be used install promtail
#
# @example when declaring the promtail class
#  class { '::profiles::monitoring::promtail': }
#
class profiles::monitoring::promtail (
  Array[Hash] $client_urls,
  String[1] $checksum = '978391a174e71cfef444ab9dc012f95d5d7eae0d682eaf1da2ea18f793452031',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Stdlib::Absolutepath $positions_file = '/tmp/positions.yaml',
  Array $scrape_configs = [
    {
      'job_name' => 'system_secure',
      'static_configs' => [{
        'targets' => ['localhost'],
        'labels'  => {
          'job'  => 'var_log_secure',
          'host' => $::fqdn,
          '__path__' => '/var/log/secure'
        }
      }]
    },
    {
      'job_name' => 'system_messages',
      'static_configs' => [{
        'targets' => ['localhost'],
        'labels'  => {
          'job'  => 'var_log_messages',
          'host' => $::fqdn,
          '__path__' => '/var/log/messages'
        }
      }]
    },
    {
      'job_name' => 'journal',
      'journal' => {
        'max_age' => '12h',
        'labels' => {
          'job'  => 'systemd_journal',
          'host' => $::fqdn,
        }
      },
      'relabel_configs' => [
        {
          'source_labels' => ['__journal__systemd_unit'],
          'target_label' => 'unit',
        }
      ]
    }
  ],
  String $sd_service_name = 'promtail',
  Array $sd_service_tags = ['metrics'],
  String[1] $version = 'v2.4.1',
) {

  $_clients_config_hash = { 'clients' => $client_urls}
  $_positions_config_hash = { 'positions' => { 'filename' => $positions_file} }
  $_scrape_configs_hash = { 'scrape_configs' => $scrape_configs}
  class { '::promtail':
    checksum              => $checksum,
    clients_config_hash   => $_clients_config_hash,
    positions_config_hash => $_positions_config_hash,
    scrape_configs_hash   => $_scrape_configs_hash,
    server_config_hash    => { 'server' => { 'http_listen_port' => 9080 , 'grpc_listen_port' => 0}},
    service_ensure        => 'running',
    version               => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => 'http://localhost:9080',
          interval => '10s'
        }
      ],
      port   => 9080,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow promtail':
      port => 9080,
    }
  }
}
