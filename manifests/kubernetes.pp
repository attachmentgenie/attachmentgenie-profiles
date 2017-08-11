# This class can be used install kubernetes components.
#
# @example when declaring the kubernetes class
#  class { '::profiles::kubernetes': }
#
# @param flannel    Manage flannel on this node.
# @param kubernetes Manage kubernetes on this node.
class profiles::kubernetes (
  Boolean $flannel = false,
  Boolean $kubernetes = false,
) {
  if $flannel {
    class { '::profiles::kubernetes::flannel': }
  }
  if $kubernetes {
    class { '::profiles::kubernetes::kubernetes': }
  }
}
