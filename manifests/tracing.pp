# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profiles::tracing
#
# @param tempo Manage tempo on this node.
class profiles::tracing (
  Boolean $tempo = false,
) {
  if $tempo {
    class { 'profiles::tracing::tempo': }
  }
}
