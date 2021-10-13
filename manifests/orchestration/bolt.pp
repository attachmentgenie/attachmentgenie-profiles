# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::orchestration::bolt
class profiles::orchestration::bolt (
  Hash $default_config = {},
  Stdlib::Absolutepath $default_config_path = '/etc/puppetlabs/bolt',
  String $package = 'puppet-bolt',
){
  package { 'bolt':
    ensure => installed,
    name   => $package,
  }

  file { $default_config_path:
    ensure => directory,
  }
  -> file { 'bolt default config':
    path    => "${default_config_path}/bolt-defaults.yaml",
    content => to_yaml($default_config),
  }
}
