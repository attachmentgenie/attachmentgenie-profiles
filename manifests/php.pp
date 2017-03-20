# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::package': }
#
# @param extensions (Hash) extensions to install.
# @param install_fpm (Boolean) install fpm.
# @param install_composer (Boolean) install composer.
# @param manage_repo (Boolean) manage repo.
# @param packages (Hash) list of packages to install
# @param settings (Hash) php conf settings.
class profiles::php (
  $extensions = {
    'intl'     => {},
    'mbstring' => {},
    'mysql'    => {},
    'mcrypt'   => {},
    'xdebug'   => {
      'package_prefix' => 'php-pecl-'
    },
    'xml'      => {},
  },
  $install_fpm = false,
  $install_composer = false,
  $manage_repo = false,
  $packages = {},
  $settings = {
    'Date/date.timezone' => 'Europe/Amsterdam'
  },
){
  class { '::php':
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