# This class can be used install packaging dependencies
#
# @example when declaring the package class
#  class { '::profiles::package': }
#
class profiles::package {
  package { 'fpm':
    ensure   => 'latest',
    provider => 'gem',
  }
}