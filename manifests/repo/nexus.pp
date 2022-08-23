# This class can be used install nexus components.
#
# @example when declaring the nexus class
#  class { '::profiles::repo::nexus': }
#
class profiles::repo::nexus (
  Stdlib::Absolutepath $data_path = '/srv',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $revision = '03',
  String $sd_service_name = 'nexus',
  Array $sd_service_tags = [],
  String $version = '3.32.0',
) {
  class { 'nexus':
    version       => $version,
    revision      => $revision,
    download_site => 'http://download.sonatype.com/nexus/3',
    nexus_type    => 'unix',
  }
  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'nexus data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Exec['nexus-untar'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow nexus':
      port => 8081,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => "http://${facts['networking']['ip']}:8081",
          interval => '10s'
        },
      ],
      port   => 8081,
      tags   => $sd_service_tags,
    }
  }
}
