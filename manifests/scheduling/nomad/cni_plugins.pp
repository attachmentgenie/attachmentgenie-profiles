# This class can be used install nomad cni plugins.
#
# @example when declaring the nomad cni plugins class
#  class { '::profiles::scheduling::nomad::cni_plugins': }
#
class profiles::scheduling::nomad::cni_plugins (
  $arch                  = 'amd64',
  $download_url          = undef,
  $download_url_base     = 'https://github.com/containernetworking/plugins/releases/download',
  $download_extension    = 'tgz',
  $package_name          = 'cni-plugins',
  Enum['none','url'] $install_method = 'url',
  String $version = 'v0.9.0',
) {
  case $install_method {
    'url': {
      $install_path = '/opt/cni/bin'
      $real_download_url = pick($download_url, "${download_url_base}/${version}/${package_name}-linux-${arch}-${version}.${download_extension}") # lint:ignore:140chars

      include 'archive'
      file { [
          '/opt/cni',
        '/opt/cni/bin']:
          ensure => directory,
      }
      -> archive { "${install_path}/cni_plugins.${download_extension}":
        ensure       => present,
        source       => $real_download_url,
        extract      => true,
        extract_path => $install_path,
        creates      => "${install_path}/bridge",
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${install_method} is invalid")
    }
  }
}
