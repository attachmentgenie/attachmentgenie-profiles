#
# Class containing default global templates
#
# This so that these aren't forced on the user.
#
class :: profiles::monitoring::icinga2::global_templates (
  Boolean $services = true;
  Boolean $usergroups = true;
  Boolean $timeperiods = true;
) {
  if ($services) {
    case $::osfamily {
      'Debian': {
        ::icinga2::object::service { 'linux_apt':
          import           => ['generic-service'],
          service_name     => 'apt',
          apply            => true,
          check_command    => 'apt',
          check_period     => '9to5',
          command_endpoint => 'host.name',
          assign           => ['NodeName'],
          target           => '/etc/icinga2/zones.d/global-templates/services.conf',
        }
      }
      default: {}
    }

    ::icinga2::object::service { 'linux_icinga':
      import           => ['generic-service'],
      service_name     => 'icinga',
      apply            => true,
      check_command    => 'icinga',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_procs':
      import           => ['generic-service'],
      service_name     => 'procs',
      apply            => true,
      check_command    => 'procs',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_users':
      import           => ['generic-service'],
      service_name     => 'users',
      apply            => true,
      check_command    => 'users',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_ssh':
      import           => ['generic-service'],
      service_name     => 'ssh',
      apply            => true,
      check_command    => 'ssh',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_load':
      import           => ['generic-service'],
      service_name     => 'load',
      apply            => true,
      check_command    => 'load',
      command_endpoint => 'host.name',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }

    ::icinga2::object::service { 'linux_disks':
      import           => ['generic-service'],
      apply            => 'disk_name => config in host.vars.disks',
      check_command    => 'disk',
      command_endpoint => 'host.name',
      vars             => 'vars + config',
      assign           => ['NodeName'],
      target           => '/etc/icinga2/zones.d/global-templates/services.conf',
    }
  }

  if ($usergroups) {
    ::icinga2::object::usergroup { 'icingaadmins':
      display_name => 'Icinga 2 Admin Group',
      target       => '/etc/icinga2/zones.d/global-templates/usergroups.conf',
    }
  }

  if ($timeperiods) {
    ::icinga2::object::timeperiod{ '24x7':
      target => '/etc/icinga2/zones.d/global-templates/timeperiods.conf',
      ranges => {
        'monday'    => '00:00-24:00',
        'tuesday'   => '00:00-24:00',
        'wednesday' => '00:00-24:00',
        'thursday'  => '00:00-24:00',
        'friday'    => '00:00-24:00',
        'saturday'  => '00:00-24:00',
        'sunday'    => '00:00-24:00',
      }
    }

    ::icinga2::object::timeperiod{ '9to5':
      target => '/etc/icinga2/zones.d/global-templates/timeperiods.conf',
      ranges => {
        'monday'    => '09:00-17:00',
        'tuesday'   => '09:00-17:00',
        'wednesday' => '09:00-17:00',
        'thursday'  => '09:00-17:00',
        'friday'    => '09:00-17:00',
      }
    }
  }
}
