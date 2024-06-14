# This class can be used install nomad cni plugins.
#
# @example when declaring the nomad cni plugins class
#  class { '::profiles::scheduling::nomad::cni_plugins': }
#
class profiles::scheduling::nomad::cni_plugins (
  String $arch                  = 'amd64',
  Optional[String] $download_url          = undef,
  String $download_url_base     = 'https://github.com/containernetworking/plugins/releases/download',
  String $download_extension    = 'tgz',
  String $package_name          = 'cni-plugins',
  Enum['none','url'] $install_method = 'url',
  String $version = 'v0.9.0',
) {
  case $install_method {
    'url': {
      $install_path = '/opt/cni'
      $real_download_url = pick($download_url, "${download_url_base}/${version}/${package_name}-linux-${arch}-${version}.${download_extension}") # lint:ignore:140chars

      include 'archive'
      file { [
          $install_path,
        "${install_path}/${package_name}-${version}"]:
          ensure => directory,
      }
      -> archive { "${install_path}/${package_name}-${version}.${download_extension}":
        ensure       => present,
        source       => $real_download_url,
        extract      => true,
        extract_path => "${install_path}/${package_name}-${version}",
        creates      => "${install_path}/${package_name}-${version}/bridge",
      }
      -> file { "${install_path}/bin":
        ensure => link,
        force  => true,
        notify => Service['nomad'],
        target => "${install_path}/${package_name}-${version}",
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
}
