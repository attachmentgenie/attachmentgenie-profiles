# This class can be used install flannel components.
#
# @example when declaring the flannel class
#  class { '::profiles::kubernetes::flannel': }
#
class profiles::kubernetes::flannel {
  class {'flannel':
    etcd_endpoints => 'http://localhost:2379',
    etcd_prefix    => '/example.com/network',
    iface          => 'enp0s8',
  }
}