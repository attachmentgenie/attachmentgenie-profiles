# This class can be used install user mailhog properties
#
# @example when declaring the mailhog class
#  class { '::profiles::mail::mailhog': }
#
# @param install_method How to install.
# @param wget_source    Location to download mailhog.
class profiles::mail::mailhog (
  String $install_method = 'package',
  Optional[String] $archive_source = undef,
){
  class { '::mailhog':
    install_method => $install_method,
    archive_source => $archive_source,
  }
}
