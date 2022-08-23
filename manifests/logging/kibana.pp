# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::logging::kibana': }
#
# @param manage_repo  Let profile install java.
# @param version      Version to install.
class profiles::logging::kibana (
  Hash[String[1], Variant[String[1], Integer, Boolean, Array, Hash]] $config = {},
  Boolean $manage_firewall_entry = true,
  Boolean $manage_repo = false,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'kibana',
  Array $sd_service_tags = [],
  String $version = present,
) {
  class { 'kibana':
    ensure      => $version,
    config      => $config,
    manage_repo => $manage_repo,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow kibana':
      port => 5601,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${facts['facts["networking"]["ip"]']}:5601",
          interval => '10s'
        },
      ],
      port   => 5601,
      tags   => $sd_service_tags,
    }
  }
}
