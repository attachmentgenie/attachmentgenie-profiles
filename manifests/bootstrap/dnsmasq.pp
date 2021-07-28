# This class can be used install dnsmasq
#
# @example when declaring the dnsmasq class
#  class { '::profiles::bootstrap::dnsmasq': }
#
class profiles::bootstrap::dnsmasq (
  Stdlib::Host $consul_client_address = '127.0.0.1',
  Boolean $forward_consul = false,
) {
  class { '::dnsmasq': }

  if $forward_consul {
    dnsmasq::conf { 'consul':
      ensure  => present,
      content => "server=/consul/${consul_client_address}#8600",
    }
  }
}
