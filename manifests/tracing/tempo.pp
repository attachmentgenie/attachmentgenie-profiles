# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::tracing::tempo
class profiles::tracing::tempo (
  Stdlib::Absolutepath $data_path = '/var/lib/tempo',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Boolean $multitenancy_enabled = false,
  String $sd_service_name = 'tempo',
  Array $sd_service_tags = [],
  String $version = '1.0.1',
  Optional[Hash] $compactor_config_hash = undef,
  Optional[Hash] $distributor_config_hash = undef,
  Optional[Hash] $ingester_config_hash = undef,
  Optional[Hash] $memberlist_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $storage_config_hash = undef,
  Optional[Hash] $query_frontend_config_hash = undef,
  Optional[Hash] $querier_config_hash = undef,
) {
  class { '::tempo':
    compactor_config_hash      => $compactor_config_hash,
    distributor_config_hash    => $distributor_config_hash,
    ingester_config_hash       => $ingester_config_hash,
    memberlist_config_hash     => $memberlist_config_hash,
    multitenancy_enabled       => $multitenancy_enabled,
    server_config_hash         => $server_config_hash,
    storage_config_hash        => $storage_config_hash,
    query_frontend_config_hash => $query_frontend_config_hash,
    querier_config_hash        => $querier_config_hash,
    version                    => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'tempo':
      device    => $device,
      mountpath => $data_path,
      before    => [File[$data_path],Service['tempo']],
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow tempo':
      port => 3100,
    }
    profiles::bootstrap::firewall::entry { '200 allow tempo grpc':
      port => 9095,
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
