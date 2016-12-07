# This class can be used install golang
#
# @example when declaring the golang class
#  class { '::profiles::golang': }
#
class profiles::golang {

  case $::osfamily {
    'redhat': {
      $developer_packages = ['golang']
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
  package { $developer_packages:
    ensure => installed,
  }
}