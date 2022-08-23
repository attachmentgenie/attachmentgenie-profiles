# This class can be used install metrics components
#
# @example when declaring the monitroin class
#  class { '::profiles::metrics': }
#
# @param carbon       Manage carbon on this node.
# @param grafana      Manage grafana on this node.
# @param graphite_web Manage graphite_web on this node.
class profiles::metrics (
  Boolean $carbon = false,
  Boolean $grafana = false,
  Boolean $graphite_web = false,
) {
  if $carbon {
    class { 'profiles::metrics::carbon': }
  }
  if $grafana {
    class { 'profiles::metrics::grafana': }
  }
  if $graphite_web {
    class { 'profiles::metrics::graphite_web': }
  }
}
