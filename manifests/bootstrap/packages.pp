# @summary Install a free form list of packages
#
# Install a free form list of packages
#
# @example
#   include profiles::bootstrap::packages
#
# @param packages Packages to install.
class profiles::bootstrap::packages (
  Optional[Array] $packages,
) {
  package { $packages:
    ensure => 'installed',
  }
}
