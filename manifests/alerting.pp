# This class can be used install alerting.
#
# @example when declaring the alerting class
#  class { '::profiles::alerting': }
#
# @param alertmanager Manage alertmanager on this node.
# @param icinga2      Manage icinga on this node.
# @param icinga2_web  Manage icingaweb on this node.
class profiles::alerting (
  Boolean $alertmanager = false,
  Boolean $icinga2= false,
  Boolean $icinga2_web = false,
) {
  if $alertmanager {
    class { '::profiles::alerting::alertmanager': }
  }
  if $icinga2 {
    class { '::profiles::alerting::icinga2': }
  }
  if $icinga2_web {
    class { '::profiles::alerting::icinga2_web': }
  }
}
