# Class to manage prometheus node exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::node_exporter': }
#
# @param collectors Enable the following collectors
# @param group Owner of textfile collector
# @param manage_firewall_entry Manage firewall entry
# @param manage_sd_service Manage consul service
# @param sd_service_tags Consul service tags
# @param version Version to install
class profiles::monitoring::prometheus::node_exporter (
  Array[String] $collectors = ['tcpstat'],
  String $group = 'node-exporter',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $sd_service_tags = ['metrics'],
  String $version = '1.3.1',
) {
  $textfile_path = "${profiles::monitoring::prometheus::data_path}/textfile"
  $_collectors = concat($collectors, "textfile.directory=${textfile_path}")

  file { $textfile_path:
    ensure => 'directory',
    owner  => 'root',
    group  => $group,
  }

  class { 'prometheus::node_exporter':
    collectors_enable => $_collectors,
    group             => $group,
    version           => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'node_exporter':
      checks => [
        {
          http     => 'http://localhost:9100',
          interval => '10s'
        },
      ],
      port   => 9100,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow node exporter':
      port => 9100,
    }
  }
}
