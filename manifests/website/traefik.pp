# Class: profiles::website::traefik
#
# This class can be used install traefik and web properties
#
# === Examples
#
# @example when declaring the traefik class
#  class { '::profiles::website::traefik': }
#
class profiles::website::traefik (
  Stdlib::Absolutepath $config_dir = '/etc/traefik.d',
  Hash $config = {
    'debug' => false,
    'logLevel' => 'ERROR',
    'defaultEntryPoints' => ['https','http']
  },
  String $consul_domain = 'consul',
  String $consul_endpoint = '127.0.0.1:8500',
  Hash $entrypoints = {
    'http'  => {
      'address' => ':80',
      'redirect' => {
        'entryPoint' => 'https',
      }
    },
    'https' => {
      'address' => ':443',
      'tls'     => {},
    },
  },
  String $version = '1.7.12',
) {
  class { 'traefik':
    config_dir  => $config_dir,
    config_hash => $config,
    version     => $version,
  }

  traefik::config::section { 'entryPoints':
    hash => $entrypoints,
  }

  traefik::config::section { 'acme':
    hash => {
      'storage'       => "${config_dir}/acme.json",
      'onHostRule'    => true,
      'entryPoint'    => 'https',
      'httpChallenge' => {
        'entryPoint' => 'http',
      }
    },
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

  traefik::config::section { 'consulCatalog':
    hash => {
      'domain'           => $consul_domain,
      'endpoint'         => $consul_endpoint,
      'exposedByDefault' => false
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
  traefik::config::section { 'retry':
    hash => {},
  }

  traefik::config::section { 'traefikLog':
    hash => {
      'filePath' => '/var/log/traefik/traefik.log'
    }
  }

  profiles::bootstrap::firewall::entry { '200 allow Traefik HTTP and HTTPS':
    port => [80,443],
  }
  profiles::bootstrap::firewall::entry { '200 allow Traefik Proxy and API/Dashboard':
    port => [8080],
  }
}
