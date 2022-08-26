# Class to manage prometheus node exporter
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::prometheus::pushgateway': }
#
# @param manage_firewall_entry Manage firewall entry
# @param manage_sd_service Manage consul service
# @param sd_service_tags Consul service tags
# @param version Version to install
class profiles::monitoring::prometheus::pushgateway (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $sd_service_tags = ['metrics'],
  String $version = '1.4.2',
) {
  class { 'prometheus::pushgateway':
    version => $version,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'pushgateway':
      checks => [
        {
          http     => 'http://localhost:9091',
          interval => '10s'
        },
      ],
      port   => 9091,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow pushgateway':
      port => 9091,
    }
  }
}
