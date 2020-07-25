# This class can be used to create a nginx vhost
#
# @example when declaring this class
#  ::profiles::website::nginx::vhost { 'foo.bar': }
#
define profiles::website::nginx::vhost (
  Stdlib::Absolutepath $www_root,
  Optional[String] $fastcgi = undef,
  Optional[String] $fastcgi_index = undef,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_sd_service = false,
  Stdlib::Port $port = 80,
  Enum['http'] $protocol = 'http',
  Array[String] $public_name = [$name],
  String $sd_service_name = $name,
  Array $sd_service_tags = [],
) {

  ::nginx::resource::server { $name:
    fastcgi       => $fastcgi,
    fastcgi_index => $fastcgi_index,
    listen_port   => $port,
    server_name   => $public_name,
    www_root      => $www_root,
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