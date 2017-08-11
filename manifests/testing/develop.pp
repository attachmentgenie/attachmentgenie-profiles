# This class can be used install develop components.
#
# @example when declaring the develop class
#  class { '::profiles::testing::develop': }
#
# @param packages Packages to install.
class profiles::testing::develop (
  Array $packages = $profiles::testing::develop::params::packages,
) inherits profiles::testing::develop::params {
  package { $packages:
    ensure => 'installed',
  }
}
