# This class can be used install develop components.
#
# @example when declaring the develop class
#  class { '::profiles::testing::develop': }
#
# @param packages Packages to install.
class profiles::testing::develop (
  Array $packages = ['git'],
) {
  package { $packages:
    ensure => 'installed',
  }
}
