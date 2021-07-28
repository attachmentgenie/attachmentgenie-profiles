# This class can be used install user mailhog properties
#
# @example when declaring the mailhog class
#  class { '::profiles::mail::mailhog': }
#
# @param install_method How to install.
# @param wget_source    Location to download mailhog.
class profiles::mail::mailhog (
  String $archive_source = 'https://github.com/mailhog/MailHog/releases/download/v1.0.1/MailHog_linux_amd64',
  String $config = '-ui-bind-addr=127.0.0.1:8025 -api-bind-addr=127.0.0.1:8025',
  String $install_method = 'package',
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $sd_service_name = 'mailhog',
  Array $sd_service_tags = ['metrics'],
){
  class { '::mailhog':
    config         => $config,
    install_method => $install_method,
    archive_source => $archive_source,
  }

  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => 'http://localhost:8025',
          interval => '10s'
        }
      ],
      port   => 8025,
      tags   => $sd_service_tags,
    }
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow mailhog':
      port => 8025,
    }
  }
}
