# This class can be used to setup flink.
#
# @example when declaring the node role
#  class { '::profiles::flink': }
#
class profiles::flink {
  class { '::flink': }
}
