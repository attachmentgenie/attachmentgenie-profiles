# This class can be used install packaging dependencies
#
# @example when declaring the package class
#  class { '::profiles::tools::package': }
#
class profiles::tools::package (
  $fpm_version = '1.13.1',
) {
  package { 'fpm':
    ensure   => $fpm_version,
    provider => 'gem',
  }
}
