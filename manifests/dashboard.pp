# This class can be used install dashboard.
#
# @example when declaring the dashboard class
#  class { '::profiles::dashboard': }
#
# @param smashing Manage smashing on this node.
class profiles::dashboard (
  Boolean $smashing = false,
) {
  if $smashing {
    class { '::profiles::dashboard::smashing': }
  }
}
