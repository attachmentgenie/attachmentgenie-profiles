# This class can be used install network components.
#
# @example when declaring the networking class
#  class { '::profiles::networking': }
#
# @param network Manage network interfaces and routes on this node.
class profiles::networking (
  Boolean $network = false,
) {
  if $network {
    class { 'profiles::networking::network': }
  }
}
