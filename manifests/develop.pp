# This class can be used install develop components.
#
# @example when declaring the develop class
#  class { '::profiles::develop': }
#
# @param packages (String) Packages to install.
class profiles::develop (
  $packages = $profiles::develop::params::packages,
) inherits profiles::develop::params {
  include ::gcc

  package { $packages: ensure => 'installed' }
}