# This class can be used install user letsencrypt properties
#
# @example when declaring the apache class
#  class { '::profiles::website::letsencrypt': }
#
# @param certs               List of certs to accuire.
# @param email_registration  Email address to register with
# @param unsafe_registration Make request anonymous.
class profiles::website::letsencrypt (
  Hash $certs = {},
  String $email_registration = '',
  Boolean $unsafe_registration = false,
) {
  class { 'letsencrypt':
    email               => $email_registration,
    unsafe_registration => $unsafe_registration,
  }

  if length($certs) > 0 {
    create_resources( 'letsencrypt::certonly', $certs)
  }
}
