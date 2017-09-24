# Class to manage rundeck puppetdb integration.
#
# Dont include this class directly.
#
class profiles::orchestration::rundeck::puppetdb {
  wget::fetch { 'install puppetdb plugin':
    source      => "https://github.com/rundeck-plugins/rundeck-puppetenterprise-nodes-plugin/releases/download/v${::profiles::orchestration::rundeck::puppetdb_version}/rundeck-puppetenterprise-nodes-plugin-${::profiles::orchestration::rundeck::puppetdb_version}.jar",
    destination => '/var/lib/rundeck/libext/',
    timeout     => 0,
    verbose     => false,
  }

  $rundeck_access_user = $::profiles::orchestration::rundeck::rundeck_user
  file { 'rundeck puppetdb node mapping':
    path    => "/etc/rundeck/defaultMapping.json",
    content => template($::profiles::orchestration::rundeck::puppetdb_template),
    group   => $::profiles::orchestration::rundeck::group,
    mode    => '0640',
    owner   => $::profiles::orchestration::rundeck::user,
  }
}
