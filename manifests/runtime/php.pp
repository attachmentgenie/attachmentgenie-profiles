# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::runtime::package': }
#
# @param extensions       Extensions to install.
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
  Boolean $install_fpm = false,
  Boolean $install_composer = false,
  Boolean $manage_repo = false,
  Hash $packages = {},
  Hash $settings = {
    'Date/date.timezone' => 'Europe/Amsterdam'
  },
  String $version = '7.0',
){
  class { '::php::globals':
    php_version => $version,
    config_root => "/etc/php/${version}",
  }
  -> class { '::php':
    manage_repos => $manage_repo,
    fpm          => $install_fpm,
    composer     => false,
    extensions   => $extensions,
    settings     => $settings,
  }
  if $install_composer {
    class { 'composer':
      target_dir => '/usr/bin',
    }
  }
  create_resources('package',$packages)
}
