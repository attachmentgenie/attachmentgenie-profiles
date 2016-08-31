class profiles::develop (
  $packages = $profiles::develop::params::packages,
) inherits profiles::develop::params {
  include ::gcc

  package { $packages: ensure => 'installed' }
}