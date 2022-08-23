# This class can be used install carbon_relay properties
#
# @example when declaring the carbon_relay class
#  class { '::profiles::monitoring::carbon_relay': }
#
# @param admin_address  Address to bind the admin interface too (ng only)
# @param carbon_caches  List of carbon caches to forward to.
# @param config_matches Forwarding instructions. (c-relay only)
# @param http_address   Address to bind admin interface to.
# @param listen_address Address to bind to.
# @param relay_type     What version of the relay to install.
class profiles::monitoring::carbon_relay (
  String $admin_address  = '127.0.0.1',
  Hash $carbon_caches    = {},
  Hash $config_matches   = {},
  String $http_address   = '127.0.0.1',
  String $listen_address = '0.0.0.0',
  Enum['carbon', 'carbon-c-relay','carbon-relay-ng'] $relay_type = 'carbon',
) {
  case $relay_type {
    'carbon-c-relay': {
      class { 'carbon_c_relay':
        config_clusters => $carbon_caches,
        config_matches  => $config_matches,
        interface       => $listen_address,
        sorted_matches  => false,
      }
    }
    'carbon-relay-ng': {
      class { 'carbon_relay_ng':
        admin_addr  => $admin_address,
        http_addr   => $http_address,
        listen_addr => $listen_address,
      }
    }
    'carbon', default: {}
  }
}
