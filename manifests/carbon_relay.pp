# This class can be used install carbon_relay properties
#
# @example when declaring the carbon_relay class
#  class { '::profiles::carbon_relay': }
#
# @param http_address (String) address to bind admin interface too.
# @param relay_type (String)
class profiles::carbon_relay (
  $admin_address  = '127.0.0.1',
  $http_address   = '127.0.0.1',
  $listen_address = '0.0.0.0',
  $relay_type     = 'carbon',
) {
  member( ['carbon', 'carbon-c-relay','carbon-relay-ng'], $relay_type )

  case $relay_type {
    'carbon-c-relay': {
      class { '::carbon_c_relay':
        interface => $listen_address,
      }
    }
    'carbon-relay-ng': {
      class { '::carbon_relay_ng':
        admin_addr  => $admin_address,
        http_addr   => $http_address,
        listen_addr => $listen_address,
      }
    }
    'carbon', default: {}
  }
}