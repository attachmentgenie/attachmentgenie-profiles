# Class to manage icinga2 slack integration.
#
# Dont include this class directly.
#
# @param icinga_endpoint  Icinga url
# @param slack_webhook    Slack url
# @param package          Packagename
# @param slack_channel    Slack channel
# @param username         Username
class profiles::monitoring::icinga2::slack (
  $icinga_endpoint,
  $slack_webhook,
  $package = 'icinga2-slack-notifications',
  $slack_channel = '#icinga',
  $username = 'slack',
) {
  package { 'icinga2-slack-notifications':
    name => $package,
  }

  icinga2::object::user { $username:
    display_name => 'slack',
    groups       => ['icingaadmins'],
    target       => '/etc/icinga2/zones.d/global-templates/users.conf',
  }

  file { '/etc/icinga2/conf.d/slack-notifications/slack-notifications-user-configuration.conf':
    ensure  => file,
    owner   => 'nagios',
    group   => 'nagios',
    mode    => '0640',
    content => template('profiles/slack-notifications-user-configuration.conf.erb'),
  }
}
