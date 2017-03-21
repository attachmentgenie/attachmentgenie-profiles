# This class can be used install compile components.
#
# @example when declaring the compile class
#  class { '::profiles::compile': }
#
class profiles::compile {
  class { '::gcc': }
}