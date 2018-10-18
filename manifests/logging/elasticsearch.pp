# This class can be used install elasticsearch components.
#
# @example when declaring the elasticsearch class
#  class { '::profiles::logging::elasticsearch': }
#
# @param instances    ES instances to start.
# @param manage_repo  Let profile install java.
# @param oss          Use purely OSS package and repository.
# @param version      Specific version to install.
class profiles::logging::elasticsearch (
  Hash $instances      = { "${::fqdn}" => {} },
  Boolean $manage_repo = false,
  Boolean $oss         = true,
  String $version      = '5.6.12',
) {

  if $manage_repo {
    class { '::elastic_stack::repo':
      oss     => $oss,
      version => split($version,'.')[0]
    }
  }

  class { '::elasticsearch':
    oss               => $oss,
    version           => $version,
    restart_on_change => true
  }
  create_resources('elasticsearch::instance', $instances)
}
