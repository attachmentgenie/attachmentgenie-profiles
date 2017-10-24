# This class can be used install fail2ban
#
# @example when declaring the apache class
#  class { '::profiles::bootstrap::fail2ban': }
#
# @param services Services to control.
class profiles::bootstrap::fail2ban (
  Array $services =['ssh', 'ssh-ddos'],
) {
  class { '::fail2ban':
    jails => $services
  }
}
