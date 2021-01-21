# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage::minio
class profiles::storage::minio (
  String $checksum = '416890f951012c482eb75f6fc09db778708578dd3914b9a63ba89054344053be',
  Hash $config = {},
  Hash $config_default = {
    'MINIO_ACCESS_KEY'  => 'admin',
    'MINIO_SECRET_KEY'  => 'supersecret',
    'MINIO_REGION_NAME' => 'us-east-1',
    'MINIO_BROWSER'     => 'on',
  },
  Stdlib::Absolutepath $data_path = '/var/lib/minio',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Stdlib::Host $listen_address = '127.0.0.1',
  Optional[Stdlib::Port::Unprivileged] $port = 9090,
  String $sd_service_name = 'minio',
  Array $sd_service_tags = ['metrics'],
  String $version = 'RELEASE.2021-01-16T02-19-44Z',
) {
  $_config = deep_merge($config_default, $config)

  class { '::minio':
    configuration          => $_config,
    checksum               => $checksum,
    checksum_type          => 'sha256',
    installation_directory => '/usr/local/bin/minio',
    listen_ip              => $listen_address,
    listen_port            => $port,
    storage_root           => $data_path,
    version                => $version,
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'minio':
      device    => $device,
      mountpath => $data_path,
      before    => [File[$data_path],Service['minio']],
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow minio':
      port => [$port],
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${::ipaddress}:${port}",
          interval => '10s'
        }
      ],
      port   => $port,
      tags   => $sd_service_tags,
    }
  }
}
