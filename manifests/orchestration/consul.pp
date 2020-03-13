# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
class profiles::orchestration::consul (
  Hash $checks = {},
  Hash $config = {},
  Hash $config_defaults = {
    'data_dir'   => '/var/lib/consul',
    'datacenter' => 'vagrant',
  },
  Stdlib::Absolutepath $config_dir = '/etc/consul.d',
  Boolean $connect = false,
  Stdlib::Port::Unprivileged $conect_grpc_port = 8502,
  String $connect_sidecar_port_range = '21000-21255',
  Optional[String[1]] $join_wan = undef,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $options = '-enable-script-checks -syslog',
  String $sd_service_name = 'consul-ui',
  Array $sd_service_tags = ['metrics'],
  Boolean $server = false,
  Hash $services = {},
  String $version = '1.7.1',
  Boolean $ui = false,
  Hash $watches = {},
) {
  if $connect {
    $connect_config = {
      'connect'    => { 'enabled' => true },
      'ports'      => { 'grpc' => $conect_grpc_port },
    }
    $_config = deep_merge($connect_config, $config)

    profiles::bootstrap::firewall::entry { '100 allow consul connect':
      port => 8502,
    }
    profiles::bootstrap::firewall::entry { '200 allow Consul Connect Sidecars':
      port => [$connect_sidecar_port_range],
    }
  } else {
    $_config = $config
  }

  if ! defined(Package['unzip']) {
    package { 'unzip':
      ensure => present,
    }
  }
  -> class { '::consul':
    config_defaults => $config_defaults,
    config_dir      => $config_dir,
    config_hash     => $_config,
    extra_options   => $options,
    join_wan        => $join_wan,
    version         => $version,
  }

  if $server {
    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '100 allow consul rpc':
        port => 8300,
      }
    }
    if $join_wan {
      if $manage_firewall_entry {
        profiles::bootstrap::firewall::entry { '100 allow consul serf WAN':
          port => 8302,
        }
      }
    }
  }
  if $ui {
    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '100 allow consul ui':
        port => 8500,
      }
    }
    if $manage_sd_service {
      ::profiles::orchestration::consul::service { $sd_service_name:
        checks => [
          {
            http     => "http://${::ipaddress}:8500",
            interval => '10s'
          }
        ],
        port   => 8500,
        tags   => $sd_service_tags,
      }
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '100 allow consul serf LAN':
      port => 8301,
    }
    profiles::bootstrap::firewall::entry { '100 allow consul DNS TCP':
      port     => 8600,
      protocol => 'tcp'
    }
    profiles::bootstrap::firewall::entry { '100 allow consul DNS UDP':
      port     => 8600,
      protocol => 'udp',
    }
  }

  create_resources(::consul::check, $checks)
  create_resources(::profiles::orchestration::consul::service, $services)
  create_resources(::consul::watch, $watches)
}
