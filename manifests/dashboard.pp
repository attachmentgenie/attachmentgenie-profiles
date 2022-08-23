# This class can be used install dashboard.
#
# @example when declaring the dashboard class
#  class { '::profiles::dashboard': }
#
# @param smashing Manage smashing on this node.
# @param icinga2  Mange icinga2web on this node.
class profiles::dashboard (
  Boolean $icinga2 = false,
  Boolean $smashing = false,
) {
  if $icinga2 {
    class { 'profiles::dashboard::icinga2': }
  }
  if $smashing {
    class { 'profiles::dashboard::smashing': }
  }
}
