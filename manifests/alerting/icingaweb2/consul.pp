# This class is used to setup the consul module on icingaweb2.
#
# It manages all the needed dependencies for setting up the consul module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::consul': }
#
class profiles::alerting::icingaweb2::consul (
  Enum['absent', 'present'] $ensure = 'present',
  String $git_repository   = 'https://github.com/attachmentgenie/icingaweb2-module-consul.git',
  Optional[String]  $git_revision     = undef,
) inherits profiles::alerting::icingaweb2 {

  icingaweb2::module { 'consul':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    require => [
      Package['git'],
    ],
  }
}
