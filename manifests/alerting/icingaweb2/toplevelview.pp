# This class is used to setup the toplevelview module on icingaweb2.
#
# It manages all the needed dependencies for setting up the toplevelview module
# and executes the kickstart.
#
# @example when including it
#   class { '::profiles::alerting::icingaweb2::toplevelview': }
#
class profiles::alerting::icingaweb2::toplevelview (
  Enum['absent', 'present'] $ensure = 'present',
  String $git_repository   = 'https://github.com/Icinga/icingaweb2-module-toplevelview.git',
  Optional[String]  $git_revision     = 'v0.3.1',
) inherits profiles::alerting::icingaweb2 {

  icingaweb2::module { 'toplevelview':
    ensure         => $ensure,
    git_repository => $git_repository,
    git_revision   => $git_revision,
    require        => [
      Package['git'],
    ],
  }
}
