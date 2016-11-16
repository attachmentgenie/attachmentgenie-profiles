# This class can be used install ne04j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::ne04j': }
#
# @param edition (String) enterprise or community.
# @param package_version (String) Version to install.
class profiles::neo4j (
  $editon          = 'community',
  $package_version = '3.0.7',
) {
  validate_string(
    $editon,
    $package_version,
  )
  class { '::neo4j' :
    edition         => $editon,
    install_java    => false,
    package_version => $package_version,
  }
}