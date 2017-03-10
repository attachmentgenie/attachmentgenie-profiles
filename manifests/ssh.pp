# This class can be used install ssh components.
#
# @example when declaring the ssh class
#  class { '::profiles::ssh': }
#
class profiles::ssh {
  class { '::ssh::client': }
  class { '::ssh::server': }
}