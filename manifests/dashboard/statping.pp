# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::dashboard::statping
class profiles::dashboard::statping (
  String $archive_source = 'https://github.com/statping/statping/releases/download/v0.90.74/statping-linux-amd64.tar.gz',
  Hash $config = {
    'connection'     => 'sqlite3',
    'language'       => 'en',
    'allow_reports'  => 'true', # lint:ignore:quoted_booleans
    'location'       => '/etc/statping',
    'sqlfile'        => '/etc/statping/statping.db',
    'disable_http'   => 'false', # lint:ignore:quoted_booleans
    'demo_mode'      => 'false', # lint:ignore:quoted_booleans
    'disable_logs'   => 'false', # lint:ignore:quoted_booleans
    'use_assets'     => 'false', # lint:ignore:quoted_booleans
    'sample_data'    => 'false', # lint:ignore:quoted_booleans
    'use_cdn'        => 'false', # lint:ignore:quoted_booleans
    'disable_colors' => 'false', # lint:ignore:quoted_booleans
  },
  String $http_addr = '127.0.0.1',
  Stdlib::Port $http_port = 8080,
  Enum['archive','package'] $install_method = 'package',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Array $sd_service_tags = [],
) {
  class { '::statping':
    archive_source => $archive_source,
    config         => $config,
    http_addr      => $http_addr,
    http_port      => $http_port,
    install_method => $install_method,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { 'statping':
      checks => [
        {
          http     => "http://${http_addr}:${http_port}",
          interval => '10s'
        }
      ],
      port   => $http_port,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow node statping':
      port => $http_port,
    }
  }
}
