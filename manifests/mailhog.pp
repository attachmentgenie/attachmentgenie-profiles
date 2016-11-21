# This class can be used install user mailhog properties
#
# @example when declaring the apache class
#  class { '::profiles::mailhog': }
#
# @param install_method (String) how to install.
# @param wget_source (String) locationt to download mailhog.
class profiles::mailhog (
  $install_method = 'package',
  $wget_source    = undef
){
  validate_string(
    $install_method,
    $wget_source
  )
  class { '::mailhog':
    install_method => $install_method,
    wget_source    => $wget_source,
  }
}