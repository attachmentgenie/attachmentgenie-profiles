# This class can be used install alerting.
#
# @example when declaring the alerting class
#  class { '::profiles::alerting': }
#
# @param alertmanager Manage alertmanager on this node.
# @param icingaweb2   Manage icingaweb on this node.
class profiles::alerting (
  Boolean $alertmanager = false,
  Boolean $icingaweb2 = false,
) {
  if $alertmanager {
    class { '::profiles::alerting::alertmanager': }
  }
  if $icingaweb2 {
    class { '::profiles::alerting::icingaweb2': }
  }
}
