# This class can be used install php
#
# @example when declaring the php class
#  class { '::profiles::package': }
#
class profiles::php {
  case $::osfamily {
    'RedHat': {
      class { '::php':
        manage_repos => false,
        fpm          => false,
        composer     => false,
        extensions   => {
          'intl'     => {},
          'mbstring' => {},
          'mysql'    => {},
          'mcrypt'   => {},
          'xdebug'   => {
            'package_prefix' => 'php-pecl-'
          },
          'xml'      => {},
        },
        settings     => {
          'Date/date.timezone' => 'Europe/Amsterdam'
        },
      }
    }
    default: {
      fail("No repo available for ${::osfamily}/${::operatingsystem}, please fork this module and add one in repo.pp")
    }
  }
  class { 'composer':
    target_dir => '/usr/bin',
  }
}