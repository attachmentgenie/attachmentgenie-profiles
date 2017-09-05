# == Class: profiles::website::uwsgi
#
# Profile for uwsgi including plugins.
#
# === Parameters
#
# @param apps               List of applications that run under uwsgi
# @param emperor_options    Extra options to set in the emperor config file
# @param group              Group the service belongs to
# @param install_pip        Use pip to install uwsgi
# @param install_python_dev Indicates if python-dev package should be installed
# @param package_name       Name of uwsgi package
# @param package_ensure     Indicates what state the package should be in
# @param package_provider   Indicates what backend to use for this package
# @param plugins            List of uwsgi plugins
# @param service_ensure     Indicates whether the service should be running
# @param service_enable     Indicates whether the service should be enabled to start
# @param service_name       Name of the running service
# @param service_provider   The specific backend for this service
# @param socket             Directory where the sockets will be created
# @param user               Indicates the user that runs the service
#
class profiles::website::uwsgi (
  Hash $apps = {},
  Hash $emperor_options = {},
  String $group = 'uwgsi',
  Boolean $install_pip = false,
  Boolean $install_python_dev = false,
  String $package_name = 'uwsgi',
  String $package_ensure = 'installed',
  String $package_provider = 'yum',
  Array $plugins = [],
  Boolean $service_ensure = true,
  Boolean $service_enable = true,
  String $service_name = 'uwsgi-emperor',
  String $service_provider = 'systemd',
  Optional[String] $socket = undef,
  String $user = 'uwgsi',
){

  # @todo needs to be in class uwsgi
  package { $plugins:
    ensure => present,
  }

  group { $group:
    ensure => present,
  }
  -> user { $user:
    ensure => present,
    shell  => '/sbin/nologin',
  }

  class { 'uwsgi':
    emperor_options    => $emperor_options,
    install_pip        => $install_pip,
    install_python_dev => $install_python_dev,
    package_name       => $package_name,
    package_ensure     => $package_ensure,
    package_provider   => $package_provider,
    service_enable     => $service_enable,
    service_ensure     => $service_ensure,
    service_provider   => $service_provider,
    socket             => $socket,
  }
  create_resources( 'uwsgi::app', $apps )
}
