# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::logstash': }
#
# @param manage_repo (Boolean)) Setup repository to install logstash from.
class profiles::logstash (
  $manage_repo = true,
){
  validate_bool(
    $manage_repo,
  )
  class { '::logstash':
    manage_repo  => $manage_repo,
  }
}