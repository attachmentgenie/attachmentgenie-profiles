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
  Optional[Hash] $distributor_config_hash = undef,
  Optional[Hash] $frontend_worker_config_hash = undef,
  Optional[Hash] $ingester_client_config_hash = undef,
  Optional[Hash] $ingester_config_hash = undef,
  Optional[Hash] $limits_config_hash = undef,
  Optional[Hash] $querier_config_hash = undef,
  Optional[Hash] $runtime_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $table_manager_config_hash = undef,
  Optional[Enum['all', 'querier', 'table-manager', 'ingester', 'distributor']] $target = undef,
  String $version = 'v2.0.0',
){

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
}
