# This class can be used install mysql
#
# @example when declaring the mysql class
#  class { '::profiles::database::mysql': }
#
class profiles::database::mysql (
  Hash $databases = {},
  Stdlib::Absolutepath $data_path = '/var/lib/mysql',
  Optional[Stdlib::Absolutepath] $device = undef,
  Boolean $manage_disk = false,
  Boolean $manage_firewall_entry = true,
  Hash $override_options = {},
  String $root_password = 'secret',
) {
  class { '::mysql::server':
    override_options => $override_options,
    root_password    => $root_password,
  }
  class { '::mysql::server::account_security': }
  create_resources(mysql::db, $databases)

  class { '::mysql::client': }

  if $manage_disk {
    ::profiles::bootstrap::disk::mount {'mysql data disk':
      device    => $device,
      mountpath => $data_path,
      before    => Package['mysql-server'],
    }
  }
  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow mysql':
      port => 3306,
    }
  }
}
