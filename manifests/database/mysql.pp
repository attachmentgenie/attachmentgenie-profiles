# This class can be used install mysql
#
# @example when declaring the mysql class
#  class { '::profiles::database::mysql': }
#
class profiles::database::mysql (
  Hash $databases = {},
  Stdlib::Absolutepath $data_path = '/var/lib/mysql',
  Optional[Stdlib::Absolutepath] $device = undef,
  String $listen_address = 'localhost',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Hash $override_options = {},
  String $root_password = 'secret',
  String $sd_service_name = 'mysql',
  Array $sd_service_tags = [],
  Hash $users = {},
) {
  $_listen_address = { 'mysqld' => { 'bind-address' => $listen_address } }
  class { 'mysql::server':
    override_options        => deep_merge($override_options, $_listen_address),
    root_password           => $root_password,
    remove_default_accounts => true,
    restart                 => true,
  }
  create_resources(::profiles::database::mysql::db, $databases)
  create_resources(::profiles::database::mysql::user, $users)

  class { 'mysql::client': }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'mysql data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Package['mysql-server'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow mysql':
      port => 3306,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${listen_address}:3306",
          interval => '10s'
        },
      ],
      port   => 3306,
      tags   => $sd_service_tags,
    }
  }
}
