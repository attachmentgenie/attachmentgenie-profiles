# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::database::postgresql::patroni
class profiles::database::postgresql::patroni (
  Boolean $manage_firewall_entry = true,
  String $package_name = 'patroni',
  Stdlib::Absolutepath $pgsql_bin_dir = '/usr/pgsql-13/bin',
  Stdlib::Absolutepath $pgsql_data_dir = '/var/lib/patroni',
  String $scope = 'patroni',
  String $superuser_password = 'changeme',
  Boolean $use_consul = false,
) {
  file { 'patroni_config_dir':
    ensure  => 'directory',
    path    => '/etc/patroni',
    owner   => 'postgres',
    group   => 'postgres',
    mode    => '0755',
    require => Package['postgresql-server'],
  }
  -> class { 'patroni':
    config_path             => '/etc/patroni/patroni.yml',
    pgsql_data_dir          => $pgsql_data_dir,
    consul_register_service => $use_consul,
    install_method          => 'package',
    manage_postgresql       => false,
    package_name            => $package_name,
    pgsql_bin_dir           => $pgsql_bin_dir,
    pgsql_parameters        => {
      'max_connections' => 5000,
    },
    bootstrap_pg_hba        => [
      'local all postgres ident',
      'host all all 0.0.0.0/0 md5',
      'host replication rep_user 0.0.0.0/0 md5',
    ],
    pgsql_pg_hba            => [
      'local all postgres ident',
      'host all all 0.0.0.0/0 md5',
      'host replication rep_user 0.0.0.0/0 md5',
    ],
    scope                   => $scope,
    superuser_password      => $superuser_password,
    use_consul              => $use_consul,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow patroni api':
      port => 8008,
    }
  }
  if $use_consul {
    Service['consul'] -> Service['patroni']
  }
}
