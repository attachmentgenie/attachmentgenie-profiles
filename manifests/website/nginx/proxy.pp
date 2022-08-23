# This class can be used to create a nginx proxy
#
# @example when declaring this class
#  ::profiles::website::nginx::proxy { 'foo.bar': }
#
define profiles::website::nginx::proxy (
  Stdlib::HTTPUrl $proxy_url,
  $client_max_body_size = undef,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_sd_service = false,
  Stdlib::Port $port = 80,
  Enum['http'] $protocol = 'http',
  Optional[String] $proxy_buffering = undef,
  Optional[String] $proxy_http_version = undef,
  String $proxy_read_timeout = '90s',
  Array $proxy_set_header = [
    'Host $host',
    'X-Real-IP $remote_addr',
    'X-Forwarded-For $proxy_add_x_forwarded_for',
    'Proxy ""',
  ],
  Array[Stdlib::Host] $public_name = [$name],
  String $sd_service_name = $name,
  Array $sd_service_tags = [],
) {
  ::nginx::resource::server { $name:
    client_max_body_size     => $client_max_body_size,
    listen_port              => $port,
    server_name              => $public_name,
    proxy                    => $proxy_url,
    proxy_buffering          => $proxy_buffering,
    proxy_http_version       => $proxy_http_version,
    proxy_read_timeout       => $proxy_read_timeout,
    proxy_set_header         => $proxy_set_header,
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
          http     => "${protocol}://${facts['networking']['ip']}:${port}",
          interval => '10s'
        },
      ],
      port   => $port,
      tags   => $sd_service_tags,
    }
  }
}
