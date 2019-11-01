# This class can be used install dnsmasq
#
# @example when declaring the dnsmasq class
#  class { '::profiles::bootstrap::dnsmasq': }
#
class profiles::bootstrap::dnsmasq (
  Stdlib::Host $client_address = '127.0.0.1',
  Boolean $forward_consul = false,
) {
  class { '::dnsmasq': }

  if $forward_consul {
    dnsmasq::conf { 'consul':
      ensure  => present,
      content => "server=/consul/${client_address}#8600",
    }
  }
}
