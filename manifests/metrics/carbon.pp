# == Class: profiles::metrics::carbon
#
# Profile for carbon metric solution
#
# === Examples
#
# @example Declaring the class
#  class { 'profiles::metrics::carbon': }
#
# === Parameters
#
# @param carbon_cache_enabled
# @param carbon_caches
# @param carbon_ensure
# @param carbon_type
# @param line_receiver_interface
# @param pickle_receiver_interface
# @param protobuf_receiver_enabled
# @param relay_type
# @param udp_listener_enabled
# @param udp_receiver_interface
# @param use_whitelist
class profiles::metrics::carbon (
  Boolean $carbon_cache_enabled = true,
  Hash $carbon_caches = {},
  String $carbon_ensure = present,
  String $carbon_type = 'carbon',
  String $line_receiver_interface = '0.0.0.0',
  String $pickle_receiver_interface = '0.0.0.0',
  String $protobuf_receiver_enabled = 'False',
  String $relay_type = 'carbon',
  String $udp_listener_enabled = 'False',
  String $udp_receiver_interface = '0.0.0.0',
  String $use_whitelist = 'True',
) {

  member( ['carbon', 'go-carbon'], $carbon_type )
  member( ['carbon', 'carbon-c-relay','carbon-relay-ng'], $relay_type )

  case $relay_type {
    'carbon': {
      $carbon_relay_enabled = true
      $carbon_relay_ensure  = 'running'
    }
    'carbon-c-relay','carbon-relay-ng', default: {
      $carbon_relay_enabled = false
      $carbon_relay_ensure  = 'stopped'
    }
  }

  profiles::bootstrap::firewall::entry { '200 allow carbon':
    port => 2003,
  }

  case $carbon_type {
    'carbon': {
      class { 'carbon':
        carbon_cache_enabled      => $carbon_cache_enabled,
        carbon_caches             => $carbon_caches,
        carbon_ensure             => $carbon_ensure,
        carbon_relay_enabled      => $carbon_relay_enabled,
        carbon_relay_ensure       => $carbon_relay_ensure,
        line_receiver_interface   => $line_receiver_interface,
        pickle_receiver_interface => $pickle_receiver_interface,
        protobuf_receiver_enabled => $protobuf_receiver_enabled,
        udp_listener_enabled      => $udp_listener_enabled,
        udp_receiver_interface    => $udp_receiver_interface,
        use_whitelist             => $use_whitelist,
      }
    }
    default: {
      fail( "Unsupported carbon type ${carbon_type}" )
    }
  }
}
