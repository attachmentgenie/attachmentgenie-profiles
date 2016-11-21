# This class can be used install user alertmanager properties
#
# @example when declaring the apache class
#  class { '::profiles::alertmanager': }
#
# @param version (String) Version to install
class profiles::alertmanager (
  $version = '0.5.0'
){
  class { '::prometheus::alert_manager':
    version => $version
  }
}