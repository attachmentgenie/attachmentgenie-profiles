# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::bootstrap::dnsmasq': }
#
# @param name_servers Name servers to use in resolv.conf
class profiles::bootstrap::dnsmasq (
  Stdlib::Host $client_address = '127.0.0.1',
  Optional[String] $domain = undef,
  Boolean $forward_consul = false,
  Array $name_servers = ['127.0.0.1'],
  Array $searchpath = [],
) {
  class { '::dnsmasq': }

  if $forward_consul {
    dnsmasq::conf { 'consul':
      ensure  => present,
      content => "server=/consul/${client_address}#8600",
    }
  }

  class { '::resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }
}
