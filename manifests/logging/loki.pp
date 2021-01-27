# This class can be used install loki components.
#
# @example when declaring the loki class
#  class { '::profiles::logging::loki': }
#
class profiles::logging::loki (
  Hash $schema_config_hash,
  Hash $storage_config_hash,
  Optional[Boolean] $auth_enabled = undef,
  Optional[Hash] $chunk_store_config_hash = undef,
  Stdlib::Absolutepath $data_path = '/var/lib/loki',
  Optional[Stdlib::Absolutepath] $device = undef,
  Optional[Hash] $distributor_config_hash = undef,
  Optional[Hash] $frontend_worker_config_hash = undef,
  Optional[Hash] $ingester_client_config_hash = undef,
  Optional[Hash] $ingester_config_hash = undef,
  Optional[Hash] $limits_config_hash = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Optional[Hash] $querier_config_hash = undef,
  Optional[Hash] $runtime_config_hash = undef,
  String $sd_service_name = 'loki',
  Array $sd_service_tags = [],
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $table_manager_config_hash = undef,
  Optional[Enum['all', 'querier', 'table-manager', 'ingester', 'distributor']] $target = undef,
  String $version = 'v2.1.0',
){
  if !defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
  class { '::loki':
    auth_enabled                => $auth_enabled,
    chunk_store_config_hash     => $chunk_store_config_hash,
    distributor_config_hash     => $distributor_config_hash,
    frontend_worker_config_hash => $frontend_worker_config_hash,
    ingester_client_config_hash => $ingester_client_config_hash,
    ingester_config_hash        => $ingester_config_hash,
    limits_config_hash          => $limits_config_hash,
    querier_config_hash         => $querier_config_hash,
    runtime_config_hash         => $runtime_config_hash,
    schema_config_hash          => $schema_config_hash,
    server_config_hash          => $server_config_hash,
    storage_config_hash         => $storage_config_hash,
    table_manager_config_hash   => $table_manager_config_hash,
    version                     => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'loki':
      device    => $device,
      mountpath => $data_path,
      before    => [File[$data_path],Service['loki']],
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow loki':
      port => 3100,
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${::ipaddress}:3100/ready",
          interval => '10s'
        }
      ],
      port   => 3100,
      tags   => $sd_service_tags,
    }
  }
}
