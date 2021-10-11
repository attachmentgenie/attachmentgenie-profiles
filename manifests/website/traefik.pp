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
  Optional[String] $acme_email_address = undef,
  Stdlib::Absolutepath $config_dir = '/etc/traefik.d',
  Hash $config = {
    'debug' => false,
    'logLevel' => 'ERROR',
  },
  String $consul_domain = 'consul',
  String $consul_endpoint = '127.0.0.1:8500',
  Enum['http','https'] $protocol = 'https',
  Boolean $expose_api = true,
  Boolean $expose_metrics = true,
  Boolean $expose_ui = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'traefik',
  Array $sd_service_tags = ['metrics'],
  Array $tls_cipher_suites = [
    'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',       # TLS 1.2
    'TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256', # TLS 1.2
    'TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256',       # TLS 1.2
    'TLS_FALLBACK_SCSV',
  ],
  Enum['VersionTLS12','VersionTLS13'] $tls_min_version = 'VersionTLS12',
  Boolean $tls_sni_strict =true,
  Boolean $use_consul = true,
  String $version = '1.7.33',
) {
  if $protocol == 'https' {
    $entrypoints = { 'defaultEntryPoints' => ['http','https'] }
    $firewall_ports = [80,443]

    traefik::config::section { 'entryPoints':
      hash => {
        'http'  => {
          'address'  => ':80',
          'redirect' => {
            'entryPoint' => 'https',
          },
        },
        'https' => {
          'address' => ':443',
          'tls'     => {
            'cipherSuites' => $tls_cipher_suites,
            'minVersion'   => $tls_min_version,
            'sniStrict'    => $tls_sni_strict,
          },
        },
      },
    }

    traefik::config::section { 'acme':
      hash => {
        'email'         => $acme_email_address,
        'storage'       => "${config_dir}/acme.json",
        'onHostRule'    => true,
        'entryPoint'    => 'https',
        'httpChallenge' => {
          'entryPoint' => 'http',
        },
      },
    }
  } else {
    $entrypoints = { 'defaultEntryPoints' => ['http'] }
    $firewall_ports = [80]

    traefik::config::section { 'entryPoints':
      hash => {
        'http'  => {
          'address'  => ':80',
        },
      },
    }
  }

  class { 'traefik':
    config_dir  => $config_dir,
    config_hash => deep_merge($config, $entrypoints),
    version     => $version,
  }

  traefik::config::section { 'accessLog':
    hash => {
      'filePath' => '/var/log/traefik/access.log',
    },
  }

  traefik::config::section { 'retry':
    hash => {},
  }

  traefik::config::section { 'traefikLog':
    hash => {
      'filePath' => '/var/log/traefik/traefik.log',
    },
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow Traefik HTTP and HTTPS':
      port => $firewall_ports,
    }
  }

  if $use_consul {
    traefik::config::section { 'consulCatalog':
      hash => {
        'domain'           => $consul_domain,
        'endpoint'         => $consul_endpoint,
        'exposedByDefault' => false,
      },
    }
  }

  if $expose_api {
    traefik::config::section { 'api':
      hash => {
        'dashboard'  => $expose_ui,
      },
    }
    if $expose_ui {
      if $manage_firewall_entry {
        profiles::bootstrap::firewall::entry { '200 allow Traefik Proxy and API/Dashboard':
          port => [8080],
        }
      }
      if $manage_sd_service {
        ::profiles::orchestration::consul::service { $sd_service_name:
          checks => [
            {
              http     => "http://${facts['networking']['ip']}:8080",
              interval => '10s'
            },
          ],
          port   => 8080,
          tags   => $sd_service_tags,
        }
      }
    }
  }

  if $expose_metrics {
    traefik::config::section { 'metrics':
      hash => {
        'prometheus' => {},
      },
    }

    traefik::config::section { 'ping':
      hash => {},
    }
  }
}
