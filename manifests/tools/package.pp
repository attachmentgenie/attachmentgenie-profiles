# This class can be used install packaging dependencies
#
# @example when declaring the package class
#  class { '::profiles::tools::package': }
#
class profiles::tools::package (
  $version = '1.12',
) {
  package { 'fpm':
    ensure   => $version,
    provider => 'gem',
  }
}
