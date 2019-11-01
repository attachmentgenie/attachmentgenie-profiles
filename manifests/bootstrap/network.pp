# This class can be used install network
#
# @example when declaring the network class
#  class { '::profiles::bootstrap::network': }
#
class profiles::bootstrap::network (
  Boolean $enable_networkmanager = true,
) {
  if $::operatingsystemmajrelease == '7' {
    $ensure = $enable_networkmanager ? {
      true    => running,
      default => stopped,
    }

    service { 'NetworkManager':
      ensure => $ensure,
      enable => $enable_networkmanager,
    }
  }
}
