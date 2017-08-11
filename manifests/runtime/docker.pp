# This class can be used install docker components.
#
# @example when declaring the docker class
#  class { '::profiles::runtime::docker': }
#
class profiles::runtime::docker {
  class { '::docker': }
}
