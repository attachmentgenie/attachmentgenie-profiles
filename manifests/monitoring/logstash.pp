# This class can be used install logstash
#
# @example when declaring the logstash class
#  class { '::profiles::monitoring::logstash': }
#
# @param config_files Content for logstash input, filters and output.
# @param ensure       Present or absent.
# @param group        Logstash group.
# @param manage_repo  Setup repository to install logstash from.
# @param repo_version Version family to install from.
# @param user         Logstash user.
# @param version      Which version of logstash to install.
class profiles::monitoring::logstash (
  Hash $config_files = {},
  Enum[absent,present] $ensure = present,
  String $group = 'root',
  Boolean $manage_repo = false,
  String $repo_version = '7.x',
  String $user = 'root',
  Boolean $version = false,
){
  class { '::logstash':
    ensure         => $ensure,
    logstash_group => $group,
    logstash_user  => $user,
    manage_repo    => $manage_repo,
    version        => $version,
  }

  create_resources(::logstash::configfile, $config_files)

  if $manage_repo {
    if $::osfamily == 'RedHat' {
      Yumrepo['elastic'] -> Package['logstash']
    }
  }
}
