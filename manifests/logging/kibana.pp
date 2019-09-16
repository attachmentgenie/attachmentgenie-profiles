# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::logging::kibana': }
#
# @param manage_repo  Let profile install java.
# @param version      Version to install.
class profiles::logging::kibana (
  Hash[String[1], Variant[String[1], Integer, Boolean, Array, Hash]] $config = {},
  Boolean $manage_repo = false,
  String $version = present,
) {
  class { '::kibana':
    ensure      => $version,
    config      => $config,
    manage_repo => $manage_repo,
  }
}
