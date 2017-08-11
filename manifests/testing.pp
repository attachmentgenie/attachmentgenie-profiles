# This class can be used install testing components.
#
# @example when declaring the testing class
#  class { '::profiles::testing': }
#
# @param develop Manage ability to develop on this node.
# @param jenkins Manage jenkins on this node.
class profiles::testing (
  Boolean $develop = false,
  Boolean $jenkins = false,
){
  if $develop {
    class { '::profiles::testing::develop': }
  }
  if $jenkins {
    class { '::profiles::testing::jenkins': }
  }
}
