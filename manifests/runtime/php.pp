# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::runtime::package': }
#
# @param config_root      Directory that contains php config.
# @param extensions       Extensions to install.
# @param fpm_package      Fpm package to install.
# @param fpm_pools        Fpm pools to to setup.
# @param fpm_service_name Fpm service name.
# @param install_fpm      Install fpm.
# @param install_composer Install composer.
# @param manage_repo      Manage repo.
# @param packages         List of packages to install
# @param settings         PHP conf settings.
# @param version          Version to install.
class profiles::runtime::php (
  String $config_root = '/etc',
  Hash $extensions = {
    'apcu'     => {},
    'intl'     => {},
    'mbstring' => {},
    'mysqlnd'    => {},
    'xdebug'   => {
      'package_prefix' => 'php-pecl-'
    },
    'xml'      => {},
  },
  Optional[String] $fpm_package = undef,
  Hash $fpm_pools = { 'www' => {} },
  Optional[String] $fpm_service_name = undef,
  Boolean $install_fpm = true,
  Boolean $install_composer = false,
  Boolean $manage_repo = false,
  Hash $packages = {},
  Hash $settings = {
    'Date/date.timezone' => 'Europe/Amsterdam'
  },
  String $version = '72',
) {
  if $manage_repo{
    class { '::profiles::runtime::php::repo':
      version => $version,
    }
  }
  class { '::php::globals':
    config_root => $config_root,
  }
  -> class { '::php':
    manage_repos     => false,
    fpm              => $install_fpm,
    fpm_package      => $fpm_package,
    fpm_pools        => {},
    fpm_service_name => $fpm_service_name,
    composer         => false,
    extensions       => $extensions,
    settings         => $settings,
  }
  if $install_composer {
    class { 'composer':
      target_dir => '/usr/bin',
    }
  }
  create_resources('package',$packages)

  create_resources('::profiles::runtime::php::pool', $fpm_pools)
}
