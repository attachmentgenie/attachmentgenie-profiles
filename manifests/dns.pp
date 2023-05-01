# This class can be used install dns.
#
# @example when declaring the dns class
#  class { '::profiles::dns': }
#
# @param bind Manage bind on this node.
class profiles::dns (
  Boolean $bind = false,
) {
  if $bind {
    class { 'profiles::dns::bind': }
  }
}
