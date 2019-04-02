# This class can be used install kibana components.
#
# @example when declaring the kibana class
#  class { '::profiles::logging::kibana': }
#
# @param config       Hash of key-value pairs for Kibana's configuration file
# @param oss          Whether to manage OSS packages
# @param manage_repo  Whether to manage the package manager repository.
# @param status       Service status.
# @param version      Version to install.
class profiles::logging::kibana (
  Hash[String[1], Variant[String[1], Integer, Boolean, Array]] $config,
  Boolean $oss                                             = false,
  Boolean $manage_repo                                     = false,
  Enum['disabled','enabled','running','unmanaged'] $status = undef,
  String $version                                          = present,
) {
  class { '::kibana':
    ensure      => $version,
    config      => $config,
    manage_repo => $manage_repo,
    status      => $status,
    oss         => $oss
  }
}
