# This class can be used install repo components
#
# @example when declaring the repo class
#  class { '::profiles::repo': }
#
class profiles::repo (
  Boolean $aptly = false,
  Boolean $nexus = false
) {
  if $aptly {
    class { '::profiles::repo::aptly': }
  }
  if $nexus {
    class { '::profiles::repo::nexus': }
  }
}
