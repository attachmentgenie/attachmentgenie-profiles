# This class can be used install dashboard.
#
# @example when declaring the dashboard class
#  class { '::profiles::dashboard': }
#
# @param smashing Manage smashing on this node.
# @param icinga2  Mange icinga2web on this node.
class profiles::dashboard (
  Boolean $smashing = false,
  Boolean $icinga2 = false,
) {
  if $smashing {
    class { '::profiles::dashboard::smashing': }
  }
  if $icinga2 {
    class { '::profiles::dashboard::icinga2': }
  }
}
