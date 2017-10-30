# This class can be used install user smashing properties
#
# @example when declaring the smashing class
#  class { '::profiles::dashboard::smashing': }
#
class profiles::dashboard::smashing {
  package { 'smashing' :
    ensure   => installed,
    provider => 'gem',
  }
}
