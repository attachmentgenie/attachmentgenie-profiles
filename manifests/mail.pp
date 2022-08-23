# This class can be used install mail.
#
# @example when declaring the mail class
#  class { '::profiles::mail': }
#
# @param mailhog Manage mailhog on this node.
class profiles::mail (
  Boolean $mailhog = false,
) {
  if $mailhog {
    class { 'profiles::mail::mailhog': }
  }
}
