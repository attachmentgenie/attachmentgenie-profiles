# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
# @example
#   profiles::orchestration::consul::prepared_query { 'namevar': }
define profiles::orchestration::consul::prepared_query (
  Array $failover_dcs,
  Enum['absent','present'] $ensure = 'present',
  Integer $failover_n = 1,
  Stdlib::Host $hostname = '127.0.0.1',
  Boolean $only_passing = true,
  Enum['http','https'] $protocol = 'http',
  Array $tags = [],
  Integer $ttl = 10,
) {
  consul_prepared_query { $name:
    ensure               => $ensure,
    protocol             => $protocol,
    hostname             => $hostname,
    service_name         => $name,
    service_failover_n   => $failover_n,
    service_failover_dcs => $failover_dcs,
    service_only_passing => $only_passing,
    service_tags         => $tags,
    ttl                  => $ttl,
  }
}
