# This class can be used install orchestration components.
#
# @example when declaring the orchestration class
#  class { '::profiles::orchestration': }
#
# @param consul      Manage consul on this node.
# @param mcollective Manage mcollective on this node.
# @param rundeck     Manage rundeck on this node.
class profiles::orchestration (
  Boolean $consul      = false,
  Boolean $mcollective = false,
  Boolean $rundeck     = false,
) {
  if $consul {
    class { 'profiles::orchestration::consul': }
  }
  if $mcollective {
    class { 'profiles::orchestration::mcollective': }
  }
  if $rundeck {
    class { 'profiles::orchestration::rundeck': }
  }
}
