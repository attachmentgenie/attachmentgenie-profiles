# This class can be used install repo components
#
# @example when declaring the gitlab gclass
#  class { '::profiles::repo': }
#
# @param aptly  Manage aptly on this node.
class profiles::repo (
  Boolean $aptly = false,
) {
  if $aptly {
    class { '::profiles::repo::aptly': }
  }
}
