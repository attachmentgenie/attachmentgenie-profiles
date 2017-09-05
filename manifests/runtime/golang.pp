# This class can be used install golang
#
# @example when declaring the golang class
#  class { '::profiles::runtime::golang': }
#
class profiles::runtime::golang {
  package { 'golang':
    ensure => installed,
  }
}
