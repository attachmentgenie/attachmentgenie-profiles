# This class can be used install consul components.
#
# @example when declaring the consul class
#  class { '::profiles::orchestration::consul': }
#
# @param checks       Consul checks,
# @param config       Consul config,
# @param domain       Resolv.conf domain
# @param name_servers Name servers to use in resolv.conf
# @param options      Additional consul start up flags.
# @param resolv       Configure resolv.conf to use consul.
# @param searchpath   Resolv.conf searchpath.
# @param server       Run as Server.
# @param services     Consul services.
# @param version      Version of consul to install.
# @param watches      Consul watches.
# @param ui           Enable UI.
class profiles::orchestration::consul (
  Hash $checks = {},
  Hash $config = {
    'data_dir'   => '/opt/consul',
    'datacenter' => 'vagrant',
  },
  Optional[String] $domain = undef,
  Array $name_servers = ['127.0.0.1'],
  String $options = '-enable-script-checks -syslog',
  Boolean $resolv = false,
  Array $searchpath = [],
  Boolean $server = false,
  Hash $services = {},
  String $version = '1.2.2',
  Boolean $ui = false,
  Hash $watches = {},
) {
  package { 'unzip':
    ensure => present,
  }
  -> class { '::consul':
    config_hash   => $config,
    extra_options => $options,
    version       => $version,
  }

  if $server {
    profiles::bootstrap::firewall::entry { '100 allow consul rpc':
      port => 8300,
    }
    profiles::bootstrap::firewall::entry { '100 allow consul serf LAN':
      port => 8301,
    }
    profiles::bootstrap::firewall::entry { '100 allow consul serf WAN':
      port => 8302,
    }
  }
  if $ui {
    profiles::bootstrap::firewall::entry { '100 allow consul ui':
      port => 8500,
    }
  }

  create_resources(::consul::check, $checks)
  create_resources(::consul::service, $services)
  create_resources(::consul::watch, $watches)

  if $resolv {
    class { '::dnsmasq': }
    dnsmasq::conf { 'consul':
      ensure  => present,
      content => 'server=/consul/127.0.0.1#8600',
    }

    class { 'resolv_conf':
      domainname  => $domain,
      nameservers => $name_servers,
      searchpath  => $searchpath,
    }
  }
}
