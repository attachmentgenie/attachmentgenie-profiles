# This class can be used install ne04j components.
#
# @example when declaring the ne04j class
#  class { '::profiles::ne04j': }
#
# @param address (String) Address to bind to.
# @param service_provider (String) Service provider.
# @param version (String) Version to install.
class profiles::neo4j (
  $address          = $::ipaddress,
  $service_provider = 'init',
  $version          = '2.3.6',
) {
  class { '::neo4j':
    address          => $address,
    service_provider => $service_provider,
    version          => $version,
  }
}