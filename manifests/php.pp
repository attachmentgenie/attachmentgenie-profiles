#
class profiles::php (
  $motd = false,
){

  require ::profiles::ruby

  case $::osfamily {
    'Debian': {

    }
    'RedHat': {
      yumrepo {'webtatic' :
        mirrorlist => 'http://mirror.webtatic.com/yum/el6/$basearch/mirrorlist',
        descr      => 'Webtatic',
        enabled    => 1,
        gpgcheck   => 1,
      } ->
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
    target_dir      => '/usr/bin',
    suhosin_enabled => false,
  }

  if $motd {
    motd::register{ 'Profile : php': }
  }
}