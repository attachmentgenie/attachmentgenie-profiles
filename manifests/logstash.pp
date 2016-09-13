# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::logstash': }
#
# @param manage_repo (Boolean)) Setup repository to install logstash from.
# @param config_files (Hash)) content for logstash input, filters and output.
class profiles::logstash (
  $manage_repo  = true,
  $config_files = {},
){
  validate_bool(
    $manage_repo,
  )
  class { '::logstash':
    logstash_group => 'root',
    logstash_user  => 'root',
    manage_repo    => $manage_repo,
  }
  create_resources(::logstash::configfile, $config_files)
}