# This class can be used install user mailhog properties
#
# @example when declaring the mailhog class
#  class { '::profiles::mail::mailhog': }
#
# @param install_method How to install.
# @param wget_source    Location to download mailhog.
class profiles::mail::mailhog (
  String $install_method = 'package',
  Optional[String] $wget_source = undef
){
  class { '::mailhog':
    install_method => $install_method,
    wget_source    => $wget_source,
  }
}
