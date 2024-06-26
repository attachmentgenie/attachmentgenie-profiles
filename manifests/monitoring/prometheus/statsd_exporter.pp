# Class to manage prometheus statsd exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::statsd_exporter': }
#
# @param manage_firewall_entry Manage firewall entry
# @param manage_sd_service Manage consul service
# @param sd_service_tags Consul service tags
# @param sd_service_tags_exporter Consul service tags for statsd endpoint
# @param version Version to install
class profiles::monitoring::prometheus::statsd_exporter (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $sd_service_tags = [],
  Array $sd_service_tags_exporter = ['metrics'],
  String $version = '0.22.4',
) {
  class { 'prometheus::statsd_exporter':
    version => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'statsd_exporter':
      checks => [
        {
          http     => 'http://localhost:9102',
          interval => '10s'
        },
      ],
      port   => 9102,
      tags   => $sd_service_tags_exporter,
    }
    ::profiles::orchestration::consul::service { 'statsd':
      checks => [
        {
          tcp      => 'localhost:9125',
          interval => '10s'
        },
      ],
      port   => 9125,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow statsd exporter':
      port => 9102,
    }
    ::profiles::bootstrap::firewall::entry { '200 allow statsd tcp':
      port => 9125,
    }
    ::profiles::bootstrap::firewall::entry { '200 allow statsd udp':
      port  => 9125,
      proto => 'udp',
    }
  }
}
