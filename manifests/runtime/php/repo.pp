# @param version          Version to install.
class profiles::runtime::php::repo (
  $version = '72'
) {
  yumrepo { "remi-php${version}":
    descr      => "Remi's PHP ${version} RPM repository",
    mirrorlist => "https://rpms.remirepo.net/enterprise/${::operatingsystemmajrelease}/php${version}/mirror",
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'https://rpms.remirepo.net/RPM-GPG-KEY-remi',
    priority   => 1,
  }
}
