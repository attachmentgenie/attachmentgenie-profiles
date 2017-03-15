# This class can be used install java components.
#
# @example when declaring the java class
#  class { '::profiles::java': }
#
# @param package (String) Package to install.
# @param package_options (Array) Additional package parameters.
class profiles::java (
  $package         = 'java-1.8.0-openjdk-devel',
  $package_options = undef,
) {
  class { '::java':
    package         => $package,
    package_options => $package_options,
  }
}
