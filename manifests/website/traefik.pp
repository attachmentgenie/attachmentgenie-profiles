# Class: profiles::website::traefik
#
# This class can be used install traefik and web properties
#
# === Examples
#
# @example when declaring the traefik class
#  class { '::profiles::website::traefik': }
#
# === Parameters
#
# @param daemon_user    User that runs traefik
# @param upstreams      Set(s) of upstream servers to use
# @param stream         Enable streaming hosts.
# @param streams        Set(s) of streams.
# @param vhosts         Set(s) of vhost to create
# @param vhost_packages Packages to manage that contain vhosts files.
class profiles::website::traefik (
  String $consul_domain = 'consul',
  String $consul_endpoint = '127.0.0.1:8500',
  String $daemon_user = 'traefik',
  Hash $upstreams = {},
  Boolean $stream = false,
  Hash $streams = {},
  String $version = '1.7.11',
  Hash $vhosts = {},
  Hash $vhost_packages = {},
) {
  class { 'traefik':
    version     => $version,
    config_hash => {},
  }

  traefik::config::section { 'traefikLog':
    hash => {
      'filePath' => '/var/log/traefik/traefik.log'
    }
  }

  traefik::config::section { 'accessLog':
    hash => {
      'filePath' => '/var/log/traefik/access.log',
    }
  }
  traefik::config::section { 'api':
    hash => {
      'dashboard'  => true,
    },
  }
  traefik::config::section { 'metrics':
    hash => {
      'prometheus' => {},
    },
  }
  traefik::config::section { 'ping':
    hash => {},
  }

  traefik::config::section { 'consulCatalog':
    hash => {
      'domain'           => $consul_domain,
      'endpoint'         => $consul_endpoint,
      'exposedByDefault' => false
    },
  }

  profiles::bootstrap::firewall::entry { '200 allow Traefik 80':
    port => [80],
  }
  profiles::bootstrap::firewall::entry { '200 allow Traefik 443':
    port => [443],
  }
  profiles::bootstrap::firewall::entry { '200 allow Traefik Proxy and API/Dashboard':
    port => [8080],
  }
}
