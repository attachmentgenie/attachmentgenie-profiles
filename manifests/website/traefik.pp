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
  String $daemon_user = 'traefik',
  Hash $upstreams = {},
  Boolean $stream = false,
  Hash $streams = {},
  Hash $vhosts = {},
  Hash $vhost_packages = {},
) {
  class { 'traefik':
    version     => '1.6.6',
    config_hash => {
      'defaultEntryPoints' => ['consul'],
      'logLevel'           => 'DEBUG'
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
      'domain'           => $::domain,
      'exposedByDefault' => false
    },
  }
  traefik::config::section { 'entryPoints':
    hash => {
      'consul' => {
        'address' => ':8030'
      },
      'er'     => {
        'address' => ':8031'
      },
    }
  }
  traefik::config::section { 'metrics':
    hash => {
      'prometheus' => {},
    },
  }
  traefik::config::section { 'ping':
    hash => {},
  }

  profiles::bootstrap::firewall::entry { '200 allow Traefik Proxy and API/Dashboard':
    port => [8080],
  }

  traefik::config::section { 'traefikLog':
    hash => {
      'filePath' => '/var/log/traefik/traefik.log'
    }
  }

  class { 'traefik::config::file':
    filename => 'rules.toml',
    watch    => true
  }
  traefik::config::file_rule { 'proxy':
    frontend => {
      entryPoints => ['er'],
      'routes'    => {
        'test_1' => {
          'rule' => 'Host:proxy.website.vagrant'
        }
      }
    },
    backend  => {
      'servers' => {
        'server1' => {
          'url'    => 'http://192.168.49.45',
        },
      }
    }
  }
}
