# This class can be used install nomad components.
#
# @example when declaring the nomad class
#  class { '::profiles::scheduling::nomad': }
#
class profiles::scheduling::nomad (
  Stdlib::Absolutepath $bin_dir = '/usr/local/bin',
  Hash $config = {},
  Hash $config_defaults = {
    'consul' => {
      'address' => '127.0.0.1:8500',
    },
    'data_dir'   => '/var/lib/nomad',
    'datacenter' => 'vagrant',
  },
  Stdlib::Absolutepath $config_dir = '/etc/nomad.d',
  Boolean $consul_connect = false,
  Stdlib::Absolutepath $data_path = '/opt/nomad',
  Optional[Stdlib::Absolutepath] $device = undef,
  Enum['url', 'package', 'none'] $install_method = 'url',
  String $job_port_range = '20000-32000',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  Boolean $manage_sd_service = true,
  Boolean $manage_service_file = true,
  Boolean $manage_sysctl = true,
  String $sd_service_check_interval = '10s',
  Stdlib::HTTPUrl $sd_service_endpoint = "http://${facts['networking']['ip']}:4646",
  String $sd_service_name = 'nomad-ui',
  Array $sd_service_tags = [],
  String $version = '1.3.0',
) {
  if $consul_connect {
    include profiles::scheduling::nomad::cni_plugins

    if $manage_sysctl {
      ::profiles::bootstrap::sysctl::entry { 'net.bridge.bridge-nf-call-arptables': }
      ::profiles::bootstrap::sysctl::entry { 'net.bridge.bridge-nf-call-ip6tables': }
      ::profiles::bootstrap::sysctl::entry { 'net.bridge.bridge-nf-call-iptables': }
    }
  }

  if $install_method == 'url' {
    if ! defined(Package['unzip']) {
      package { 'unzip':
        ensure => present,
      }
    }
    Package['unzip'] -> Archive <||>
  }

  if $install_method == 'package' {
    $_bin_dir = '/bin'
  } else {
    $_bin_dir = $bin_dir
  }

  class { 'nomad':
    bin_dir             => $_bin_dir,
    config_defaults     => $config_defaults,
    config_dir          => $config_dir,
    config_hash         => $config,
    install_method      => $install_method,
    manage_repo         => $manage_package_repo,
    manage_service_file => $manage_service_file,
    version             => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'nomad data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Service['nomad'],
    }
  }
  if $manage_firewall_entry {
    # https://www.nomadproject.io/docs/job-specification/network.html#dynamic-ports
    ::profiles::bootstrap::firewall::entry { '200 allow Nomad services':
      port => [$job_port_range],
    }
    ::profiles::bootstrap::firewall::entry { '200 allow Nomad http':
      port => [4646],
    }
    ::profiles::bootstrap::firewall::entry { '200 allow Nomad rpc':
      port => [4647],
    }
    ::profiles::bootstrap::firewall::entry { '200 allow Nomad serf':
      port => [4648],
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => $sd_service_endpoint,
          interval => $sd_service_check_interval,
        },
      ],
      port   => 4646,
      tags   => $sd_service_tags,
    }
  }
}
