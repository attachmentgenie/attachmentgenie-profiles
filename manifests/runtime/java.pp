# This class can be used install java components.
#
# @example when declaring the java class
#  class { '::profiles::runtime::java': }
#
# @param package         Package to install.
# @param package_options Additional package parameters.
class profiles::runtime::java (
  String $package = 'java-11-openjdk-devel',
  Optional[String] $package_options = undef,
) {
  class { 'java':
    package         => $package,
    package_options => $package_options,
  }
}
