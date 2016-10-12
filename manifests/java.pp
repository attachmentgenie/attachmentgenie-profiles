# This class can be used install java components.
#
# @example when declaring the java class
#  class { '::profiles::java': }
#
# @param package (String) Package to install.
class profiles::java (
  $package = 'java-1.8.0-openjdk-devel',
) {
  class { '::java':
    package => $package,
  }
}