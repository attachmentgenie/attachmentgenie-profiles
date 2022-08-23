# This class can be used install runtime components.
#
# @example when declaring the runtime class
#  class { '::profiles::runtime': }
#
# @param docker Manage docker on this node.
# @param java   Manage java on this node.
# @param golang Manage golang on this node.
# @param nodejs Manage nodejs on this node.
# @param php    Manage php on this node.
# @param python Manage python on this node.
# @param ruby   Manage ruby on this node.
# @param scala  Manage scala on this node.
class profiles::runtime (
  Boolean $docker = false,
  Boolean $java   = false,
  Boolean $golang = false,
  Boolean $nodejs = false,
  Boolean $php    = false,
  Boolean $python = false,
  Boolean $ruby   = false,
  Boolean $scala  = false,
) {
  if $docker {
    class { 'profiles::runtime::docker': }
  }
  if $java {
    class { 'profiles::runtime::java': }
  }
  if $golang {
    class { 'profiles::runtime::golang': }
  }
  if $nodejs {
    class { 'profiles::runtime::nodejs': }
  }
  if $php {
    class { 'profiles::runtime::php': }
  }
  if $python {
    class { 'profiles::runtime::python': }
  }
  if $ruby {
    class { 'profiles::runtime::ruby': }
  }
  if $scala {
    class { 'profiles::runtime::scala': }
  }
}
