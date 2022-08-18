# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::monitoring::grafana_agent
class profiles::monitoring::grafana_agent (
  Optional[Hash] $intergrations_config_hash = undef,
  Optional[Hash] $loki_config_hash = undef,
  Optional[Hash] $prometheus_config_hash = undef,
  Optional[Hash] $server_config_hash = undef,
  Optional[Hash] $tempo_config_hash = undef,
  String[1] $version = 'v0.26.1',
){
  if !defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
  class { 'grafana_agent':
    intergrations_config_hash => $intergrations_config_hash,
    loki_config_hash          => $loki_config_hash,
    prometheus_config_hash    => $prometheus_config_hash,
    server_config_hash        => $server_config_hash,
    tempo_config_hash         => $tempo_config_hash,
    version                   => $version,
  }
}
