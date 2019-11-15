# This class can be used install nomad components.
#
# @example when declaring the nomad class
#  class { '::profiles::scheduling::nomad': }
#
class profiles::scheduling::nomad (
  Hash $config = {},
  Hash $config_defaults = {
    'consul' => {
      'address' => '127.0.0.1:8500',
    },
    'data_dir'   => '/var/lib/nomad',
    'datacenter' => 'vagrant',
  },
  Stdlib::Absolutepath $config_dir = '/etc/nomad.d',
  String $job_port_range = '20000-32000',
  Optional[String[1]] $join_wan = undef,
  String $version = '0.10.1',
){
  if !defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
  class {'nomad':
    config_defaults => $config_defaults,
    config_dir      => $config_dir,
    config_hash     => $config,
    join_wan        => $join_wan,
    version         => $version,
  }

  # https://www.nomadproject.io/docs/job-specification/network.html#dynamic-ports
  profiles::bootstrap::firewall::entry { '200 allow Nomad services':
    port => [$job_port_range],
  }

  profiles::bootstrap::firewall::entry { '200 allow Nomad http':
    port => [4646],
  }
  profiles::bootstrap::firewall::entry { '200 allow Nomad rpc':
    port => [4647],
  }
  profiles::bootstrap::firewall::entry { '200 allow Nomad serf':
    port => [4648],
  }
}
