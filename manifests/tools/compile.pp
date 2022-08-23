# This class can be used install compile components.
#
# @example when declaring the compile class
#  class { '::profiles::tools::compile': }
#
class profiles::tools::compile {
  class { 'gcc': }
}
