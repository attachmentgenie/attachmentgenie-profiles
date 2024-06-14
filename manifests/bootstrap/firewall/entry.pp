# This class can be used install user firewall properties
#
# @example when declaring the firewall class
#   ::profiles::bootstrap::firewall::entry { '200 allow influxdb':
#     port => [8086, 8088],
#   }
#
# @param chain        User base chain.
# @param destination  Destination to use.
# @param interface    Interface to describe.
# @param jump         jump to perform.
# @param port         System port.
# @param proto        proto to use.
# @param protocol     protocol to use.
# @param source       Source to use.
# @param state        Packet State
# @param table        The table to add the rule to
define profiles::bootstrap::firewall::entry (
  Profiles::FirewallChain $chain = 'INPUT',
  Optional[Stdlib::IP::Address] $destination = undef,
  Optional[String] $interface = undef,
  Profiles::FirewallJump $jump = 'accept',
  Optional[Variant[Integer, Array[Integer],Array[String]]] $port = undef,
  Profiles::FirewallProto $proto = 'tcp',
  Profiles::FirewallProtocol $protocol = 'iptables',
  Optional[Stdlib::IP::Address] $source = undef,
  Optional[Variant[Profiles::FirewallState, Array[Profiles::FirewallState]]] $state = undef,
  String $table = 'filter',
) {
  firewall { $name:
    jump     => $jump,
    chain    => $chain,
    proto    => $proto,
    protocol => $protocol,
    table    => $table,
  }

  if $destination {
    Firewall[$name] {
      destination => $destination,
    }
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

  if $source {
    Firewall[$name] {
      source => $source,
    }
  }

  if $state {
    Firewall[$name] {
      state => $state,
    }
  }
}
