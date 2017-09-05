# This class can be used install etcd components.
#
# @example when declaring the etcd class
#  class { '::profiles::database::etcd': }
#
class profiles::database::etcd {
  class { '::etcd':
    listen_client_urls          => 'http://0.0.0.0:2379',
    initial_advertise_peer_urls => 'http://localhost:2379',
    advertise_client_urls       => 'http://localhost:2379',
    cluster_enabled             => false,
    proxy                       => 'off'
  }
}