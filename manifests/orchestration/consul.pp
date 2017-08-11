# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param config  Consul config,
# @param options Additional consul start up flags.
# @param version Version of consul to install,
class profiles::orchestration::consul (
  Hash $config    = {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'vagrant1',
  },
  String $options = '-enable-script-checks -syslog',
  String $version = '0.9.2',
) {
  package { 'unzip':
    ensure => present,
  }
  -> class { '::consul':
    config_hash   => $config,
    extra_options => $options,
    version       => $version,
  }
}
