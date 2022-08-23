# This class can be used install security components.
#
# @example when declaring the security class
#  class { '::profiles::security': }
#
# @param selinux Manage selinux on this node.
class profiles::security (
  Boolean $selinux = false,
  Boolean $vault = false,
) {
  if $selinux {
    class { 'profiles::security::selinux': }
  }

  if $vault {
    class { 'profiles::security::vault': }
  }
}
