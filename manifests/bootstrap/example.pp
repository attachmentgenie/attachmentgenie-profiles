# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::bootstrap::example
class profiles::bootstrap::example (
  Boolean $client = true,
  Hash $config = {},
  Hash $config_default = {},
  String $database_grant = 'all',
  String $database_name = 'example',
  String $database_password = 'example',
  String $database_user = 'example',
  Stdlib::Absolutepath $data_path = '/var/lib/example',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $expose_api = false,
  Boolean $expose_metrics = false,
  Boolean $expose_ui = false,
  Stdlib::Host $listen_address = '127.0.0.1',
  Boolean $manage_database = false,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_package_repo = false,
  Boolean $manage_sd_service = false,
  Boolean $manage_sudoersd = false,
  Boolean $manage_sysctl = false,
  Optional[Stdlib::Port::Unprivileged] $port = 8080,
  Optional[String] $runmode = undef,
  String $sd_service_check_interval = '10s',
  Optional[Stdlib::HTTPUrl] $sd_service_endpoint = undef,
  String $sd_service_name = 'example',
  Array $sd_service_tags = ['metrics'],
  Boolean $server = false,
) {
  $_config = deep_merge($config_default, $config)

  class {'::example':
    #client  => $client,
    #config  => $_config,
    #runmode => $runmode,
    #server  => $server,
  }

  if $manage_database {
    profiles::database::postgresql::db { $database_name:
      grant    => $database_grant,
      password => $database_password,
      user     => $database_user,
    }
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'example':
      device    => $device,
      mountpath => $data_path,
      before    => Package['example'],
    }
  }

  if $expose_api {
    if $expose_ui {
      if $manage_firewall_entry {
        profiles::bootstrap::firewall::entry { '200 allow Example':
          port => [$port],
        }
      }

      if $manage_sd_service {
        if $sd_service_endpoint {
          $_check_endpoint = $sd_service_endpoint
        } else {
          $_check_endpoint = "http://${listen_address}:${port}"
        }
        ::profiles::orchestration::consul::service { $sd_service_name:
          checks => [
            {
              http     => $_check_endpoint,
              interval => $sd_service_check_interval,
            }
          ],
          port   => $port,
          tags   => $sd_service_tags,
        }
      }
    }
  }

  #if $expose_metrics {}

  #if $manage_package_repo {}

  #if $manage_sudoersd {}

  if $manage_sysctl {
    ::profiles::bootstrap::sysctl::entry {'net.bridge.bridge-nf-call-arptables':}
  }
}
