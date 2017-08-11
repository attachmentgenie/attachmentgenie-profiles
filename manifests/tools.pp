# This class can be used install tools components.
#
# @example when declaring the tools class
#  class { '::profiles::tools': }
#
# @param compile Manage ability to compile on this node.
# @param package Manage abiltiy to create packages on this node.
class profiles::tools (
  Boolean $compile = false,
  Boolean $package = false,
){
  if $compile {
    class { '::profiles::tools::compile': }
  }
  if $package {
    class { '::profiles::tools::package': }
  }
}
