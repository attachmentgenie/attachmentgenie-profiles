# This class can be used install carbon_relay properties
#
# @example when declaring the carbon_relay class
#  class { '::profiles::carbon_relay': }
#
# @param admin_address (String) address to bind the admin interface too (ng only)
# @param carbon_caches (Hash) List of carbon caches to forward to.
# @param config_matches (Hash) Forwarding instructions. (c-relay only)
# @param http_address (String) address to bind admin interface to.
# @param listen_address (String) addres to bind to.
# @param relay_type (String)
class profiles::carbon_relay (
  $admin_address  = '127.0.0.1',
  $carbon_caches  = {},
  $config_matches = {},
  $http_address   = '127.0.0.1',
  $listen_address = '0.0.0.0',
  $relay_type     = 'carbon',
) {
  member( ['carbon', 'carbon-c-relay','carbon-relay-ng'], $relay_type )

  case $relay_type {
    'carbon-c-relay': {
      class { '::carbon_c_relay':
        config_clusters => $carbon_caches,
        config_matches  => $config_matches,
        interface       => $listen_address,
        sorted_matches  => false,
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