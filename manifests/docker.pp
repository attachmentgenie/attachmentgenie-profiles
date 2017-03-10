# This class can be used install docker components.
#
# @example when declaring the docker class
#  class { '::profiles::docker': }
#
class profiles::docker {
  class { '::docker': }
}