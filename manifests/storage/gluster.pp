# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::storage::gluster
class profiles::storage::gluster (
  Stdlib::Absolutepath $data_path = '/var/lib/gluster',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_repo = true,
  Boolean $manage_sd_service = false,
  Hash $mounts = {},
  Hash $peers = {},
  String[1] $pool = 'production',
  String[1] $release = '9.3',
  String $sd_service_name = 'gluster',
  Array $sd_service_tags = [],
  Boolean $use_exported_resources = false,
  String[1] $version = '9.3',
  Hash $volumes = {},
) {
  class { '::gluster::repo':
    release => $release,
  }
  -> class { '::gluster':
    server                 => true,
    client                 => true,
    repo                   => $manage_repo,
    pool                   => $pool,
    use_exported_resources => $use_exported_resources,
    version                => $version,
  }

  create_resources('gluster::mount', $mounts)

  $peers_defaults = {
    pool    => $pool,
    require => Class[::gluster::service],
  }
  create_resources('gluster::peer', $peers, $peers_defaults)

  create_resources('gluster::volume', $volumes)

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'gluster':
      device    => $device,
      mountpath => $data_path,
    }
    Profiles::Bootstrap::Disk::Mount['gluster'] -> Service['glusterd']
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow gluster':
      port => [24007, 49152],
    }
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${::ipaddress}:24007",
          interval => '10s'
        },
        {
          script   => '/bin/bash -c "sudo -n /usr/sbin/gluster pool list |grep -v UUID|grep -v localhost|grep Connected"',
          interval => '10s',
          timeout  => '5s'
        }
      ],
      port   => 24007,
      tags   => $sd_service_tags,
    }
  }
}
