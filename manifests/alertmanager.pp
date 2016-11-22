# This class can be used install user alertmanager properties
#
# @example when declaring the apache class
#  class { '::profiles::alertmanager': }
#
# @param install_method (String) how to install
# @param version (String) Version to install
class profiles::alertmanager (
  $install_method = 'package',
  $version        = '0.5.0'
){
  validate_string(
    $install_method,
    $version,
  )
  class { '::prometheus::alert_manager':
    install_method => $install_method,
    version        => $version
  }
}