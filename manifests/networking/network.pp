# @summary This class can be used configure network interfaces and routes
#
# A description of what this class does
#
# @example
#   include profiles::networking::network
#
# @param interfaces   Additional interfaces.
# @param routes       Additional routes.
class profiles::networking::network (
  Hash $interfaces = {},
  Hash $routes = {},
) {
  include 'network'

  if ( $interfaces!= {}) {
    create_routes( network_config, $interfaces )
  }
  if ( $routes != {}) {
    create_routes( network_route, $routes )
  }
}
