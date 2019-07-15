# This class can be used install influxdb
#
# @example when declaring the influxdb class
#  class { '::profiles::bootstrap::resolv': }
#
# @param name_servers Name servers to use in resolv.conf
class profiles::bootstrap::resolv (
  Optional[String] $domain = undef,
  Array $name_servers = ['127.0.0.1'],
  Array $searchpath = [],
) {
  class { '::resolv_conf':
    domainname  => $domain,
    nameservers => $name_servers,
    searchpath  => $searchpath,
  }
}
