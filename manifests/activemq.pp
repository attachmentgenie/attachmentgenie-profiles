class profiles::activemq (
  $memoryusage         = '200 mb',
  $storeusage          = '1 gb',
  $tempusage           = '1 gb',
  $console             = false,
  $instance            = 'mcollective',
  $mq_admin_username   = 'mco-admin',
  $mq_admin_password   = 'marionette',
  $mq_cluster_username = 'mco-cluster',
  $mq_cluster_password = 'marionette',
  $version             = '5.9.1-2.el6',
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
