# This class can be used to create a php-fpm pool
#
# @example when declaring the firewall class
#  class { '::profiles::runtime::php::pool': }
#
# @param address                  Ipaddress to bind to.
# @param cachetool_config         Install cachetool config.
# @param cachetool_config_dir     directory to install cachetool config in.
# @param port                     Port to bind to.
# @param process_manager          Way to run the fpm process manager.
# @param type                     Way to run fpm.
define profiles::runtime::php::pool (
  Stdlib::IP::Address $address = '127.0.0.1',
  Boolean $cachetool_config = true,
  Optional[Stdlib::Absolutepath] $cachetool_config_dir = undef,
  Stdlib::Port::Unprivileged $port = 9000,
  Enum['static','dynamic','ondemand'] $process_manager = 'static',
  Enum['port','socket'] $type = 'port',
) {
  case $type {
    'port': {
      $fpm_listen = "${address}:${port}"
      if $address != '127.0.0.1' {
        profiles::bootstrap::firewall::entry { "100 allow fpm pool ${port}":
          port => $port,
        }
      }
    }
    'socket': {
      $fpm_listen = "/var/run/${name}-pool.sock"
    }
    default: {
      fail("Installation method ${type} not supported")
    }
  }
  php::fpm::pool { $name:
    access_log     => "/var/log/php-fpm/${name}-pool.log",
    listen         => $fpm_listen,
    pm             => $process_manager,
    pm_status_path => "/${name}_status",
  }

  if $cachetool_config {
    $config_path = $cachetool_config_dir ? {
      undef   => '/etc/cachetool.yml',
      default => "/${cachetool_config_dir}/.cachetool.yml",
    }
    file {'cachetool config':
      ensure  => 'present',
      content => template('profiles/runtime/php/cachetool.yml.erb'),
      path    => $config_path,
    }
  }
}