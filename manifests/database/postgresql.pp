# This class can be used install postgresql
#
# @example when declaring the postgresql class
#  class { '::profiles::database::postgresql': }
#
class profiles::database::postgresql (
  $databases = {},
  Stdlib::Absolutepath $data_path = '/var/lib/pgsql/data',
  Optional[Stdlib::Absolutepath] $device = undef,
  $encoding = 'UTF-8',
  Optional[Hash] $hba_rules = undef,
  $ip_mask_allow_all_users = '127.0.0.1/32',
  $listen_address = 'localhost',
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_package_repo = false,
  Boolean $manage_sd_service = false,
  Boolean $patroni = false,
  String $sd_service_name = 'postgresql',
  Array $sd_service_tags = ['metrics'],
  String $superuser_password = 'changeme',
  $version = '13',
) {
  $_service_ensure = $patroni ? { true => 'stopped', default => 'running' }
  class { 'postgresql::globals':
    datadir             => $data_path,
    encoding            => $encoding,
    manage_datadir      => ! $manage_disk,
    manage_package_repo => $manage_package_repo,
    version             => $version,
  }
  -> class { 'postgresql::server':
    ip_mask_allow_all_users => $ip_mask_allow_all_users,
    listen_addresses        => $listen_address,
    postgres_password       => $superuser_password,
    service_ensure          => $_service_ensure,
    service_enable          => ! $patroni,
  }
  create_resources(::profiles::database::postgresql::db, $databases)

  class { 'postgresql::client': }

  if $hba_rules and $hba_rules != {} {
    create_resources(postgresql::server::pg_hba_rule, $hba_rules, { 'postgresql_version' => $version })
  }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount { 'postgresql':
      device    => $device,
      mountpath => dirname($data_path),
      before    => Package['postgresql-server'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow pgsql':
      port => 5432,
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${listen_address}:5432",
          interval => '10s'
        },
      ],
      port   => 5432,
      tags   => $sd_service_tags,
    }
  }
  if $patroni {
    $_package_name = $manage_sd_service ? { true => 'patroni', default => 'patroni-consul' }
    class { 'profiles::database::postgresql::patroni':
      manage_firewall_entry => $manage_firewall_entry,
      package_name          => $_package_name,
      pgsql_data_dir        => $data_path,
      superuser_password    => $superuser_password,
      use_consul            => ! $manage_sd_service,
    }
  }
}
