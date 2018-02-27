# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::runtime::package': }
#
# @param config_root      Directory that contains php config.
# @param extensions       Extensions to install.
# @param fpm_package      Fpm package to install.
# @param fpm_service_name Fpm service name.
# @param install_fpm      Install fpm.
# @param install_composer Install composer.
# @param manage_repo      Manage repo.
# @param packages         List of packages to install
# @param settings         PHP conf settings.
# @param version          Version to install.
class profiles::runtime::php (
  Hash $extensions = {
    'intl'     => {},
    'mbstring' => {},
    'mysql'    => {},
    'mcrypt'   => {},
    'xdebug'   => {
      'package_prefix' => 'php-pecl-'
    },
    'xml'      => {},
  },
  Optional[String] $fpm_package = undef,
  Optional[String] $fpm_service_name = undef,
  Boolean $install_fpm = false,
  Boolean $install_composer = false,
  Boolean $manage_repo = false,
  Hash $packages = {},
  Hash $settings = {
    'Date/date.timezone' => 'Europe/Amsterdam'
  },
  String $version = '7.2',
  # cant use alphabetic order here as we want to reuse the version #
  String $config_root = "/etc/php/${version}",
){
  class { '::php::globals':
    php_version => $version,
    config_root => $config_root,
  }
  -> class { '::php':
    manage_repos     => $manage_repo,
    fpm              => $install_fpm,
    fpm_package      => $fpm_package,
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
}
