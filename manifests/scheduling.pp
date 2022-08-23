# This class can be used install scheduling components.
#
# @example when declaring the scheduling class
#  class { '::profiles::scheduling': }
#
# @param nomad    Manage nomad on this node.
class profiles::scheduling (
  Boolean $nomad = false,
) {
  if $nomad {
    class { 'profiles::scheduling::nomad': }
  }
}
