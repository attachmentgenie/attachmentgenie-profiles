# This class can be used install carbon_relay properties
#
# @example when declaring the carbon_relay class
#  class { '::profiles::carbon_relay': }
#
# @param relay_type (String)
class profiles::carbon_relay (
  $relay_type = 'carbon',
) {
  member( ['carbon', 'carbon-c-relay','carbon-relay-ng'], $relay_type )

  case $relay_type {
    'carbon-c-relay': {
      class { '::carbon_c_relay': }
    }
    'carbon-relay-ng': {
      class { '::carbon_relay_ng': }
    }
    'carbon', default: {}
  }
}