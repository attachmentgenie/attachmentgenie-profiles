# This class can be used install nodejs
#
# @example when declaring the nodejs class
#  class { '::profiles::nodejs': }
#
class profiles::nodejs {
  class { '::nodejs': }
}
