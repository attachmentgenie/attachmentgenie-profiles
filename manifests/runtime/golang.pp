# This class can be used install golang
#
# @example when declaring the golang class
#  class { '::profiles::runtime::golang': }
#
class profiles::runtime::golang {
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
