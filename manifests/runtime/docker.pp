# This class can be used install docker components.
#
# @example when declaring the docker class
#  class { '::profiles::runtime::docker': }
#
class profiles::runtime::docker (
  Optional[Variant[String,Array]] $dns_servers = undef,
  Hash $registries = {},
) {
  include systemd

  class { 'docker':
    dns => $dns_servers,
  }

  create_resources('::docker::registry', $registries)
}
