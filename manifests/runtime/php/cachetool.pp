# This class can be used to install cachetool
#
# @example when declaring the firewall class
#  class { '::profiles::runtime::php::cachetool': }
#
# @param group            Group of file
# @param install_dir      Install directory
# @param install_method   Install type.
# @param package_name     Package name.
# @param package_version  Version to be installed.
# @param phar_source      Download source.
# @param user             Owner of the file.
class profiles::runtime::php::cachetool (
  Optional[String] $group   = undef,
  Stdlib::Absolutepath $install_dir = '/usr/local/bin',
  Profiles::InstallMethod $install_method = 'archive',
  String $package_name = 'cachetool',
  String $package_version = 'installed',
  String $phar_source = 'http://gordalina.github.io/cachetool/downloads/cachetool.phar',
  String $user = 'root',
) {
  case $install_method {
    'package': {
      package { 'cachetool':
        ensure => $package_version,
        name   => $package_name,
      }
    }
    'archive': {
      wget::fetch { 'cachetool':
        cache_dir   => '/usr/local/tmp',
        destination => "${install_dir}/cachetool",
        execuser    => $user,
        mode        => '0755',
        group       => $group,
        source      => $phar_source,
        timeout     => 0,
      }
    }
    default: {
      fail("Installation method ${install_method} not supported")
    }
  }
}
