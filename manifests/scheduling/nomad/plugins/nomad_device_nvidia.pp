# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::scheduling::nomad::plugins::nomad_device_nvidia
#
# @param arch
#   cpu architecture
# @param download_extension
#   archive type to download
# @param download_url
#   download url to download from
# @param download_url_base
#   download hostname to down from
# @param install_method
#   install via download and extract from a url.
# @param version
#   Specify version of nomad binary to download.
class profiles::scheduling::nomad::plugins::nomad_device_nvidia (
  Enum['386', 'amd64', 'arm','arm64'] $arch = 'amd64',
  String[1] $download_extension             = 'zip',
  Optional[String[1]] $download_url         = undef,
  String[1] $download_url_base              = 'https://releases.hashicorp.com',
  Enum['none', 'url'] $install_method       = 'url',
  String[1] $version                        = '1.0.0',
) {
  $package_name = 'nomad-device-nvidia'
  $real_download_url = pick($download_url, "${download_url_base}/${package_name}/${version}/${package_name}_${version}_linux_${arch}.${download_extension}") # lint:ignore:140chars

  case $install_method {
    'url': {
      include 'archive'

      file { "${nomad::plugin_dir}/${package_name}-${version}":
        ensure => directory,
      }
      -> archive { "${nomad::plugin_dir}/${package_name}-${version}.${nomad::download_extension}":
        ensure       => present,
        source       => $real_download_url,
        extract      => true,
        extract_path => "${nomad::plugin_dir}/${package_name}-${version}",
        creates      => "${nomad::plugin_dir}/${package_name}-${version}/${package_name}",
      }
      -> file { "${nomad::plugin_dir}/${package_name}":
        ensure => link,
        notify => $nomad::notify_service,
        target => "${nomad::plugin_dir}/${package_name}-${version}/${package_name}",
      }
    }
    'none': {}
    default: {
      fail("The provided install method ${nomad::install_method} is invalid")
    }
  }
}
