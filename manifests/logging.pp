# This class can be used install logging.
#
# @example when declaring the logging class
#  class { '::profiles::logging': }
#
# @param elasticsearch Manage elasticsearch on this node.
# @param kibana        Manage kibana on this node.
class profiles::logging (
  Boolean $elasticsearch = false,
  Boolean $kibana = false,
  Boolean $loki = false,
) {
  if $elasticsearch {
    class { '::profiles::logging::elasticsearch': }
  }
  if $kibana {
    class { '::profiles::logging::kibana': }
  }
  if $loki {
    class { '::profiles::logging::loki': }
  }
}
