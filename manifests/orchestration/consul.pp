# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param checks   Consul checks,
# @param config   Consul config,
# @param options  Additional consul start up flags.
# @param services Consul services.
# @param version  Version of consul to install.
# @param watches  Consul watches.
class profiles::orchestration::consul (
  Hash $checks    = {},
  Hash $config    = {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'vagrant',
  },
  String $options = '-enable-script-checks -syslog',
  Hash $services  = {},
  String $version = '0.9.3',
  Hash $watches   = {},
) {
  package { 'unzip':
    ensure => present,
  }
  -> class { '::consul':
    config_hash   => $config,
    extra_options => $options,
    version       => $version,
  }

  create_resources(::consul::check, $checks)
  create_resources(::consul::service, $services)
  create_resources(::consul::watch, $watches)
}
