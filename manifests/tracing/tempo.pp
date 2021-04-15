# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::tracing::tempo
class profiles::tracing::tempo (
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'tempo',
  Array $sd_service_tags = [],
  String $version = '0.6.0',
  Optional[Boolean] $auth_enabled = undef,
  Optional[Hash] $compactor_config_hash = undef,
  Optional[Hash] $distributor_config_hash = undef,
  Optional[Hash] $ingester_config_hash = undef,
  Optional[Hash] $memberlist_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $storage_config_hash = undef,
) {
  class { '::tempo':
    auth_enabled            => $auth_enabled,
    compactor_config_hash   => $compactor_config_hash,
    distributor_config_hash => $distributor_config_hash,
    ingester_config_hash    => $ingester_config_hash,
    memberlist_config_hash  => $memberlist_config_hash,
    server_config_hash      => $server_config_hash,
    storage_config_hash     => $storage_config_hash,
    version                 => $version,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow tempo':
      port => 3100,
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "http://${::ipaddress}:3100",
          interval => '10s'
        }
      ],
      port   => 3100,
      tags   => $sd_service_tags,
    }
  }
}
