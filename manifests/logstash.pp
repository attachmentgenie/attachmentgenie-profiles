# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::logstash': }
#
# @param config_files (Hash) content for logstash input, filters and output.
# @param ensure (String) present or absent.
# @param manage_repo (Boolean) Setup repository to install logstash from.
# @param repo_version (String) Version family to install from.
# @param version (String) Which version of logstash to install.
class profiles::logstash (
  $config_files = {},
  $ensure       = present,
  $manage_repo  = false,
  $repo_version = '5.x',
  $version      = false,
){
  validate_bool(
    $manage_repo,
  )
  validate_string(
    $ensure,
  )
  class { '::logstash':
    ensure         => $ensure,
    logstash_group => 'root',
    logstash_user  => 'root',
    manage_repo    => $manage_repo,
    repo_version   => $repo_version,
    version        => $version,
  }
  create_resources(::logstash::configfile, $config_files)
}