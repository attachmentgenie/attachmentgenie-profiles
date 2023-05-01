# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage::minio
class profiles::storage::minio (
  String $checksum                                   =
    'b665126482965f5c9d46189b21545221ea59b9caa051660adbf2e911464e6768',
  String $client_checksum                            =
    '43f5a8ea5b0387c56f6c81f42bf6cc05942a5956eba9c088d0fe351b3e990b07',
  String $client_version                             = 'RELEASE.2021-09-02T09-21-27Z',
  Hash $config                                       = {},
  Hash $config_default                               = {
    'MINIO_ROOT_USER'     => 'admin',
    'MINIO_ROOT_PASSWORD' => 'supersecret',
    'MINIO_REGION_NAME'   => 'us-east-1',
    'MINIO_BROWSER'       => 'on',
  },
  Stdlib::Absolutepath $data_path                    = '/var/lib/minio',
  Optional[Stdlib::Absolutepath] $device             = undef,
  Boolean $manage_disk                               = false,
  Boolean $manage_firewall_entry                     = true,
  Boolean $manage_sd_service                         = false,
  Stdlib::Host $listen_address                       = '127.0.0.1',
  Stdlib::Port::Unprivileged $port_api               = 9090,
  Stdlib::Port::Unprivileged $port_console           = 9091,
  String $sd_service_name                            = 'minio',
  Array $sd_service_tags                             = ['metrics'],
  String $version                                    = 'RELEASE.2021-09-09T21-37-07Z',
) {
  $console_config = {
    'MINIO_OPTS' => "--console-address ${listen_address}:${port_console}",
  }
  $_config = deep_merge($config_default, $config)

  class { 'minio':
    configuration          => $_config,
    checksum               => $checksum,
    checksum_type          => 'sha256',
    installation_directory => '/usr/local/bin/minio',
    listen_ip              => $listen_address,
    listen_port            => $port_api,
    storage_root           => $data_path,
    version                => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'minio':
      device    => $device,
      mountpath => $data_path,
      before    => [File[$data_path], Service['minio']],
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow minio':
      port => [$port_api, $port_console],
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${facts['networking']['ip']}:${port_api}",
          interval => '10s'
        },
      ],
      port   => $port_api,
      tags   => $sd_service_tags,
    }
  }
}
