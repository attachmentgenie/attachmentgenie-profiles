# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#  class { '::profiles::bootstrap::firewall': }
#
# @param action     Action to perform.
# @param chain      User base chain
# @param interface  Interface to describe.
# @param port       System port.
# @param protocol   Protocol to use.
# @param provider   Provider to use.
# @param state      Packet State
define profiles::bootstrap::firewall::entry (
  Profiles::FirewallAction $action = 'accept',
  Profiles::FirewallChain $chain = 'INPUT',
  Optional[String] $interface = undef,
  Optional[Variant[Integer, Array[Integer]]] $port = undef,
  Profiles::FirewallProtocol $protocol = 'tcp',
  Profiles::FirewallProvider $provider = 'iptables',
  Optional[Variant[Profiles::FirewallState, Array[Profiles::FirewallState]]] $state = undef,
) {
  firewall { $name:
    action   => $action,
    chain    => $chain,
    proto    => $protocol,
    provider => $provider,
  }

  if $interface {
    Firewall[$name] {
      iniface => $interface,
    }
  }

  if $port {
    Firewall[$name] {
      dport => $port,
    }
  }

  if $state {
    Firewall[$name] {
      state => $state,
    }
  }
}
