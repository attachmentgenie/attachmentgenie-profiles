# == Class: profiles::uwsgi
#
# Profile for uwsgi including plugins.
#
# === Parameters
#
# @param apps [Hash] list of applications that run under uwsgi
# @param emperor_options [Hash] extra options to set in the emperor config file
# @param gid [String] group the service belongs to
# @param install_pip [Boolean] use pip to install uwsgi
# @param install_python_dev [Boolean] indicates if python-dev package should be installed
# @param package_name [String] name of uwsgi package
# @param package_ensure [String] indicates what state the package should be in
# @param package_provider [String] indicates what backend to use for this package
# @param plugins [Array] list of uwsgi plugins
# @param service_ensure [Boolean] indicates whether the service should be running
# @param service_enable [Boolean] indicates whether the service should be enabled to start
# @param service_name [String] name of the running service
# @param service_provider [String] the specific backend for this service
# @param socket directory where the sockets will be created
# @param uid [String] indicates the user that runs the service
#
class profiles::uwsgi (
  $apps               = {},
  $emperor_options    = {},
  $gid                = 'uwgsi',
  $install_pip        = false,
  $install_python_dev = false,
  $package_name       = 'uwsgi',
  $package_ensure     = 'installed',
  $package_provider   = 'yum',
  $plugins            = [],
  $service_ensure     = true,
  $service_enable     = true,
  $service_name       = 'uwsgi-emperor',
  $service_provider   = 'systemd',
  $socket             = undef,
  $uid                = 'uwgsi',
){

  # @todo needs to be in class uwsgi
  package { $plugins:
    ensure => present,
  }

  group { $gid:
    ensure => present,
  }
  -> user { $uid:
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
