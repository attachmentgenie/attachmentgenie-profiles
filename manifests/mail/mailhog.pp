# This class can be used install user mailhog properties
#
# @example when declaring the mailhog class
#  class { '::profiles::mail::mailhog': }
#
# @param install_method How to install.
# @param wget_source    Location to download mailhog.
class profiles::mail::mailhog (
  String $config = '-ui-bind-addr=127.0.0.1:8025 -api-bind-addr=127.0.0.1:8025',
  String $install_method = 'package',
  String $archive_source = 'https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64',
){
  class { '::mailhog':
    config         => $config,
    install_method => $install_method,
    archive_source => $archive_source,
  }
}
