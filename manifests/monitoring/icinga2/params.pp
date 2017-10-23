# Class to manage icinga2 parameters.
#
# Dont include this class directly.
#
class profiles::monitoring::icinga2::params {
  case $::osfamily {
    'Debian': {
      $group           = 'nagios'
      $owner           = 'nagios'
      $plugins_package = 'monitoring-plugins-standard'
    }
    'RedHat': {
      $group           = 'icinga'
      $owner           = 'icinga'
      $plugins_package = 'nagios-plugins-all'
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}, currently only supports Debian and RedHat")
    }
  }
}
