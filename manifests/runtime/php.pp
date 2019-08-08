# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::runtime::package': }
#
# @param collect_resources    Collect Exported Resources.
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
# @param resource_tag         Only export resources that are using this tag.
# @param settings             PHP conf settings.
# @param settings_default     PHP conf settings.
# @param version              Version to install.
# @param xdebug               Install xdebug extension.
# @param xdebug_config        Xdebug settings.
class profiles::runtime::php (
  Boolean $collect_resources = true,
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
  String $resource_tag = $::fqdn,
  Hash $settings = {},
  Hash $settings_default = {
    'Date/date.timezone'          => 'Europe/Amsterdam',
    'PHP/allow_url_fopen'         => 0,
    'PHP/assert.active'           => 0,
    'PHP/session.cookie_httponly' => 0,
    'PHP/display_errors'          => 0,
    'PHP/disable_functions'       => 'exec, passthru, shell_exec, system, proc_open, popen, curl_exec, curl_multi_exec',
    'PHP/display_startup_errors'  => 0,
    'PHP/error_reporting'         => 'E_ALL',
    'PHP/expose_php'              => 0,
    'PHP/file_uploads'            => 0,
    'PHP/log_errors'              => 1,
    'PHP/max_execution_time'      => '30',
    'PHP/max_input_time'          => '30',
    'PHP/memory_limit'            => '128M',
    'PHP/open_basedir'            => '/var/vhosts:/usr/local/bin',
    'PHP/post_max_size'           => '2M',
    'PHP/realpath_cache_size'     => '4096K',
    'PHP/realpath_cache_ttl'      => '600',
    'PHP/register_globals'        => 0,
    'PHP/session.cookie_lifetime' => '3600',
    'PHP/session.hash_function'   => 'sha256',
    'PHP/referer_check'           => 0,
    'PHP/session.use_strict_mode' => 1,
    'PHP/upload_tmp_dir'          => '/var/tmp',
    'PHP/upload_max_filesize'     => '32M',
    'PHP/max_file_uploads'        => 5,
    'PHP/zend.assertions'         => 0,
  },
  String $version = '73',
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
      target_dir => '/usr/local/bin',
    }
  }

  package { $modules:
    ensure => present,
  }

  $pool_defaults = {
    'cachetool_config' => $install_cachetool,
    'tag'              => $resource_tag,
  }
  create_resources('::profiles::runtime::php::pool', $fpm_pools, $pool_defaults)

  if $collect_resources {
    Profiles::Runtime::Php::Pool <<| tag == $resource_tag and env == $::environment |>>
  }
}

