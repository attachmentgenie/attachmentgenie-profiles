# == Class: profiles::carbon
#
# Profile for carbon metric solution
#
# === Examples
#
# @example Declaring the class
#  class { 'profiles::carbon': }
#
# === Parameters
#
# @param carbon_cache_enabled (Boolean)
# @param carbon_caches (Hash)
# @param carbon_ensure (String)
# @param carbon_type (String)
# @param line_receiver_interface (String)
# @param pickle_receiver_interface (String)
# @param protobuf_receiver_enabled (Boolean)
# @param relay_type (String)
# @param udp_listener_enabled (Boolean)
# @param udp_receiver_interface (String)
# @param use_whitelist (Boolean)
#
class profiles::carbon (
  $carbon_cache_enabled      = true,
  $carbon_caches             = {},
  $carbon_ensure             = present,
  $carbon_type               = 'carbon',
  $line_receiver_interface   = '0.0.0.0',
  $pickle_receiver_interface = '0.0.0.0',
  $protobuf_receiver_enabled = 'False',
  $relay_type                = 'carbon',
  $udp_listener_enabled      = 'False',
  $udp_receiver_interface    = '0.0.0.0',
  $use_whitelist             = 'True',
) {

  member( ['carbon', 'go-carbon'], $carbon_type )
  member( ['carbon', 'carbon-c-relay'], $relay_type )

  $carbon_relay_enabled = $relay_type ? {
    'carbon' => true,
    default  => false
  }

  case $carbon_type {
    'carbon': {
      class { 'carbon':
        carbon_cache_enabled      => $carbon_cache_enabled,
        carbon_caches             => $carbon_caches,
        carbon_ensure             => $carbon_ensure,
        carbon_relay_enabled      => $carbon_relay_enabled,
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
