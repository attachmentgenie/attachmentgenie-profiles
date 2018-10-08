# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::runtime::package': }
#

# @param extensions           Extensions to install.
# @param extensions_default   Extensions to install.
# @param fpm_package          Fpm package to install.
# @param fpm_pools            Fpm pools to to setup.
# @param fpm_service_name     Fpm service name.
# @param install_cachetool    Install cachetool.
# @param install_composer     Install composer.
# @param install_fpm          Install fpm.
# @param manage_repo          Manage repo.
# @param modules              PHP modules to install
# @param settings             PHP conf settings.
# @param settings_default     PHP conf settings.
# @param version              Version to install.
# @param xdebug               Install xdebug extension.
# @param xdebug_config        Xdebug settings.
class profiles::runtime::php (
  Hash $extensions = {},
  Hash $extensions_default = {
    'apcu'     => {
      'ini_prefix'      => '40-',
      'package_prefix'  => 'php-pecl-',
      'settings'        => {
        'enabled'    => 1,
        'enable_cli' => 1,
        'shm_size'   => '256M',
        'ttl'        => '0',
      },
      'settings_prefix' => 'apc',
    },
    'gd'       => {},
    'intl'     => {},
    'json'     => {},
    'mbstring' => {},
    'mysqlnd'  => {},
    'opcache'  => {
      'ini_prefix'      => '10-',
      'settings'        => {
        'enable'                  => 1,
        'enable_cli'              => 1,
        'interned_strings_buffer' => 8,
        'max_accelerated_files'   => 20000,
        'memory_consumption'      => 256,
        'revalidate_freq'         => 60 ,
      },
      'zend'            => true,
    },
    'pdo'      => {},
    'xml'      => {},
  },
  Optional[String] $fpm_package = undef,
  Hash $fpm_pools = {},
  Optional[String] $fpm_service_name = undef,
  Boolean $install_cachetool = true,
  Boolean $install_composer = false,
  Boolean $install_fpm = true,
  Boolean $manage_repo = false,
  Array $modules = [],
  Hash $settings = {},
  Hash $settings_default = {
    'Date/date.timezone'         => 'Europe/Amsterdam',
    'PHP/display_errors'         => 'Off',
    'PHP/display_startup_errors' => 'Off',
    'PHP/error_reporting'        => 'E_ALL',
    'PHP/expose_php'             => 'Off',
    'PHP/log_errors'             => 'On',
    'PHP/max_execution_time'     => '3600',
    'PHP/max_input_time'         => '3600',
    'PHP/memory_limit'           => '128M',
    'PHP/post_max_size'          => '32M',
    'PHP/realpath_cache_size'    => '4096K',
    'PHP/realpath_cache_ttl'     => '600',
    'PHP/file_uploads'           => 1,
    'PHP/upload_tmp_dir'         => '/var/tmp',
    'PHP/upload_max_filesize'    => '32M',
    'PHP/max_file_uploads'       => 5,
  },
  String $version = '72',
  Boolean $xdebug = false,
  Hash $xdebug_config = {
    'cli_color'                     => 1,
    'coverage_enable'               => 1,
    'force_display_errors'          => 1,
    'force_error_reporting'         => 1,
    'idekey'                        => 'supersecret',
    'profiler_enable'               => 0,
    'profiler_enable_trigger'       => 1,
    'profiler_enable_trigger_value' => 'supersecret',
    'remote_autostart'              => 0,
    'remote_enable'                 => 1,
    'remote_host'                   => 'localhost',
    'remote_port'                   => 9090,
    'scream'                        => 0,
  },
) {
  if $manage_repo{
    class { '::profiles::runtime::php::repo':
      version => $version,
    }
  }

  Php::Extension {
    ini_prefix      => '20-',
    settings_prefix => true,
  }

  if $xdebug {
    $extension_xdebug_config = {
      'xdebug' => {
        'ini_prefix'     => '15-',
        'package_prefix' => 'php-pecl-',
        'settings'       => $xdebug_config,
        'zend'           => true,
      },
    }
  } else {
    # @todo make php module uninstall module config properly.
    $extension_xdebug_config = {}
    file { 'xdebug config':
      ensure => 'absent',
      path   => '/etc/php.d/15-xdebug.ini',
    }
  }

  class { '::php':
    manage_repos     => false,
    fpm              => $install_fpm,
    fpm_package      => $fpm_package,
    fpm_pools        => {},
    fpm_service_name => $fpm_service_name,
    composer         => false,
    extensions       => deep_merge($extensions_default, $extension_xdebug_config, $extensions),
    pear             => false,
    settings         => deep_merge($settings_default, $settings),
  }

  if $install_cachetool {
    include ::profiles::runtime::php::cachetool
  }
  if $install_composer {
    class { '::composer':
      target_dir => '/usr/bin',
    }
  }

  package { $modules:
    ensure => present,
  }

  $pool_defaults = {
    'cachetool_config' => $install_cachetool,
    'tag'              => $::environment,
  }
  create_resources('::profiles::runtime::php::pool', $fpm_pools, $pool_defaults)
  Profiles::Runtime::Php::Pool <<| env == $::environment |>>
}
