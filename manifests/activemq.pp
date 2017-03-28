# This class can be used install user activemq properties
#
# @example when declaring the activemq class
#  class { '::profiles::activemq': }
#
# @param instance (String) Instance name.
# @param mq_admin_username (String) admin username.
# @param mq_admin_password (String) admin password.
# @param mq_cluster_username (String) cluster username.
# @param mq_cluster_password (String) cluster password.
# @param version (String) Which version to install.
# @param webconsole (Boolean) install webconsole.
class profiles::activemq (
  $instance            = 'mcollective',
  $mq_admin_username   = 'mco-admin',
  $mq_admin_password   = 'marionette',
  $mq_cluster_username = 'mco-cluster',
  $mq_cluster_password = 'marionette',
  $version             = '5.9.1-2.el7',
  $webconsole          = true,
) {
  class { '::activemq':
    instance            => $instance,
    mq_admin_username   => $mq_admin_username,
    mq_admin_password   => $mq_admin_password,
    mq_cluster_username => $mq_cluster_username,
    mq_cluster_password => $mq_cluster_password,
    mq_cluster_brokers  => [$::fqdn],
    version             => $version,
    webconsole          => $webconsole,
  }
  file { '/usr/share/activemq/activemq-data':
    ensure  => 'link',
    target  => '/var/cache/activemq/data',
    require => Package['activemq'],
    notify  => Service['activemq'],
  }
}
