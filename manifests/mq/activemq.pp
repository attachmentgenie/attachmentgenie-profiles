# This class can be used install user activemq properties
#
# @example when declaring the activemq class
#  class { '::profiles::mq::activemq': }
#
# @param instance            Instance name.
# @param mq_admin_username   Admin username.
# @param mq_admin_password   Admin password.
# @param mq_cluster_username Cluster username.
# @param mq_cluster_password Cluster password.
# @param version             Which version to install.
# @param webconsole          Install webconsole.
class profiles::mq::activemq (
  String $instance = 'mcollective',
  String $mq_admin_username = 'mco-admin',
  String $mq_admin_password = 'marionette',
  String $mq_cluster_username = 'mco-cluster',
  String $mq_cluster_password = 'marionette',
  String $version = '5.9.1-2.el7',
  Boolean $webconsole = true,
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
