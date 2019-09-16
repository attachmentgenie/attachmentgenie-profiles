# This class can be used install opendistro components.
#
# @example when declaring the opendistro class
#  class { '::profiles::logging::opendistro': }
#
# @param manage_repo  Let profile install java.
# @param version      Version to install.
class profiles::logging::opendistro (
  Boolean $manage_repo = false,
  String $version = present,
) {
  class { '::opendistro':
    ensure      => $version,
    manage_repo => $manage_repo,
  }
}
