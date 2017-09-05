# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::monitoring::logstash': }
#
# @param config_files Content for logstash input, filters and output.
# @param ensure       Present or absent.
# @param manage_repo  Setup repository to install logstash from.
# @param repo_version Version family to install from.
# @param version      Which version of logstash to install.
class profiles::monitoring::logstash (
  Hash $config_files = {},
  Enum[absent,present] $ensure = present,
  Boolean $manage_repo = false,
  String $repo_version = '5.x',
  Boolean $version = false,
){
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
