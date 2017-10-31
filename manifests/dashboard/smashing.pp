# This class can be used install user smashing properties
#
# @example when declaring the smashing class
#  class { '::profiles::dashboard::smashing': }
#
# @param provider   Package provider
class profiles::dashboard::smashing (
  String $provider = 'gem'
){
  package { 'smashing' :
    ensure   => installed,
    provider => $provider,
  }
}
