# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::website::traefik2
class profiles::website::traefik2 (
  Hash $dynamic_config = {},
  Boolean $expose_api = true,
  Boolean $expose_metrics = true,
  Boolean $expose_ui = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Enum['http','https'] $protocol = 'https',
  String $sd_service_name = 'traefik',
  Array $sd_service_tags = ['metrics'],
  Hash $static_config = {},
  Integer $traefik_api_port = 8080,
  String $version = '2.3.0',
) {
  if $protocol == 'https' {
    $firewall_ports = [80,443]
  } else {
    $firewall_ports = [80]
  }

  class { '::traefik2':
    dynamic_config => $dynamic_config,
    version        => $version,
    static_config  => $static_config,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow Traefik HTTP and HTTPS':
      port => $firewall_ports,
    }
  }

  if $expose_api {
    if $expose_ui {
      if $manage_firewall_entry {
        profiles::bootstrap::firewall::entry { '200 allow Traefik Proxy and API/Dashboard':
          port => [$traefik_api_port],
        }
      }
      if $manage_sd_service {
        ::profiles::orchestration::consul::service { $sd_service_name:
          checks => [
            {
              http     => "http://${::ipaddress}:${traefik_api_port}/ping/",
              interval => '10s'
            }
          ],
          port   => $traefik_api_port,
          tags   => $sd_service_tags,
        }
      }
    }
  }

  #if $expose_metrics {}
}
