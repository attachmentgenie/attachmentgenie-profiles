# Class to manage prometheus node exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::blackbox_exporter': }
#
class profiles::monitoring::prometheus::blackbox_exporter (
  String $extra_options = '',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Hash $modules = {},
  Array $sd_service_tags = ['metrics'],
  String $version = '0.19.0',
) {
  class { '::prometheus::blackbox_exporter':
    modules => $modules,
    version => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'blackbox_exporter':
      checks => [
        {
          http     => 'http://localhost:9115',
          interval => '10s'
        }
      ],
      port   => 9115,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow blackbox_exporter':
      port => 9115,
    }
  }
}