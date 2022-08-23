# This class can be used install docker components.
#
# @example when declaring the docker class
#  class { '::profiles::runtime::docker': }
#
class profiles::runtime::docker (
  Hash $registries = {},
) {
  class { 'docker': }

  create_resources('::docker::registry', $registries)
}
