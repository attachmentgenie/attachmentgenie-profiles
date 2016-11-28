# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::logstash': }
#
# @param config_files (Hash)) content for logstash input, filters and output.
# @param manage_repo (Boolean)) Setup repository to install logstash from.
# @param repo_version (String)) Version family to install from.
class profiles::logstash (
  $config_files = {},
  $manage_repo  = false,
  $repo_version = '2.4',
){
  validate_bool(
    $manage_repo,
  )
  class { '::logstash':
    logstash_group => 'root',
    logstash_user  => 'root',
    manage_repo    => $manage_repo,
    repo_version   => $repo_version,
  }
  create_resources(::logstash::configfile, $config_files)
}