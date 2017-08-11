# This class can be used install mq components.
#
# @example when declaring the mq class
#  class { '::profiles::mq': }
#
# @param activemq Manage activemq on this node.
class profiles::mq (
  Boolean $activemq = false,
) {
  if $activemq {
    class { '::profiles::mq::activemq': }
  }
}
