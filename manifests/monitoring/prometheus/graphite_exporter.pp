# Class to manage prometheus graphite exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::graphite_exporter': }
#
# @param manage_firewall_entry Manage firewall entry
# @param manage_sd_service Manage consul service
# @param sd_service_tags Consul service tags
# @param sd_service_tags_exporter Consul service tags for graphite endpoint
# @param version Version to install
class profiles::monitoring::prometheus::graphite_exporter (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $sd_service_tags = [],
  Array $sd_service_tags_exporter = ['metrics'],
  String $version = '0.12.0',
) {
  class { 'prometheus::graphite_exporter':
    version => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'graphite_exporter':
      checks => [
        {
          http     => 'http://localhost:9108',
          interval => '10s'
        },
      ],
      port   => 9108,
      tags   => $sd_service_tags_exporter,
    }
    ::profiles::orchestration::consul::service { 'graphite':
      checks => [
        {
          tcp      => 'localhost:9109',
          interval => '10s'
        },
      ],
      port   => 9109,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow graphite exporter':
      port => 9108,
    }
    ::profiles::bootstrap::firewall::entry { '200 allow graphite tcp':
      port => 9109,
    }
    ::profiles::bootstrap::firewall::entry { '200 allow graphite udp':
      port  => 9109,
      proto => 'udp',
    }
  }
}
