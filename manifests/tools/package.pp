# This class can be used install packaging dependencies
#
# @example when declaring the package class
#  class { '::profiles::tools::package': }
#
class profiles::tools::package {
  package { 'fpm':
    ensure   => 'latest',
    provider => 'gem',
  }
}
