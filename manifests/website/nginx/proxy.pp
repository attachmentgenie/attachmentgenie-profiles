# This class can be used to create a nginx proxy
#
# @example when declaring this class
#  ::profiles::website::nginx::proxy { 'foo.bar': }
#
define profiles::website::nginx::proxy (
  Stdlib::HTTPUrl $proxy_url,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_sd_service = false,
  Stdlib::Port $port = 80,
  Enum['http'] $protocol = 'http',
  Stdlib::Host $public_name = $name,
  String $sd_service_name = $name,
  Array $sd_service_tags = [],
) {

  ::nginx::resource::server { $name:
    listen_port              => $port,
    server_name              => [$public_name],
    proxy                    => $proxy_url,
    proxy_max_temp_file_size => '0k',
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { "100 allow ${sd_service_name}":
      port => $port,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "${protocol}://${::ipaddress}:${port}",
          interval => '10s'
        }
      ],
      port   => $port,
      tags   => $sd_service_tags,
    }
  }
}
