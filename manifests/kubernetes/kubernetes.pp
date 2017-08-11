# This class can be used install kubernetes.
#
# @example when declaring the kubernetes class
#  class { '::profiles::kubernetes::kubernetes': }
#
class profiles::kubernetes::kubernetes {
    include ::kubernetes::master
    include ::kubernetes::client

    class { 'kubernetes::master::apiserver':
      advertise_address        => '0.0.0.0',
      insecure_bind_address    => '0.0.0.0',
      bind_address             => '0.0.0.0',
      service_cluster_ip_range => '10.254.1.0/16',
      admission_control        => [
        'NamespaceLifecycle',
        'NamespaceExists',
        'LimitRanger',
        'SecurityContextDeny',
        'ResourceQuota',
      ],
    }
    class { 'kubernetes::master::controller_manager': }
    class { 'kubernetes::master::scheduler': }
    class { 'kubernetes::node::kubelet': }
    class { 'kubernetes::node::kube_proxy': }
}
