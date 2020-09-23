# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage::minio
class profiles::storage::minio (
  String $checksum = '4682d5fdce193d10a8561c0eb9e911ea69a183ad9d209bd36f59ac2beeed8357',
  Hash $config = {},
  Hash $config_default = {
    'version' => '19',
    'credential' => {
      'accessKey' => 'admin',
      'secretKey' => 'supersecret',
    },
    'region' => 'us-east-1',
    'browser' => 'on',
  },
  Stdlib::Absolutepath $data_path = '/var/lib/minio',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Stdlib::Host $listen_address = '127.0.0.1',
  Optional[Stdlib::Port::Unprivileged] $port = 9090,
  String $sd_service_name = 'example',
  Array $sd_service_tags = ['metrics'],
  String $version = 'RELEASE.2020-09-21T22-31-59Z',
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
