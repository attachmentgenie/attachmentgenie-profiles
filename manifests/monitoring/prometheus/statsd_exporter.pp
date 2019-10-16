# Class to manage prometheus statsd exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::statsd_exporter': }
#
class profiles::monitoring::prometheus::statsd_exporter (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $version = '0.12.2',
) {
  class { '::prometheus::statsd_exporter':
    version => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'statsd_exporter':
      checks => [
        {
          http     => 'http://localhost:9102',
          interval => '10s'
        }
      ],
      port   => 9102,
    }
    ::profiles::orchestration::consul::service { 'statsd':
      checks => [
        {
          http     => 'http://localhost:9125',
          interval => '10s'
        }
      ],
      port   => 9125,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow statsd exporter':
      port => 9102,
    }
    ::profiles::bootstrap::firewall::entry { '200 allow statsd':
      port => 9125,
    }
  }
}