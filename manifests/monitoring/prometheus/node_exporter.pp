# Class to manage prometheus node exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::node_exporter': }
#
class profiles::monitoring::prometheus::node_exporter (
  Array $collectors =  ['diskstats','filesystem','loadavg','meminfo','netdev','stat','tcpstat','time','vmstat'],
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $version = '0.18.1',
) {
  class { '::prometheus::node_exporter':
    collectors => $collectors,
    version    => $version,
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
    ::profiles::bootstrap::firewall::entry { '200 allow node exporter':
      port => 9100,
    }
  }
}