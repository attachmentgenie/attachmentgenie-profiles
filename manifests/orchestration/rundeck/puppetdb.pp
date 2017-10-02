# Class to manage rundeck puppetdb integration.
#
# Dont include this class directly.
#
# @param group            Rundeck group.
# @param template         Template to create mapping file.
# @param rundeck_user     Rundeck user
# @param version          What version to install.
# @param user             Rundeck user
class profiles::orchestration::rundeck::puppetdb (
  $group,
  $template,
  $rundeck_user,
  $user,
  $version,
){
  wget::fetch { 'install puppetdb plugin':
    source      => "https://github.com/rundeck-plugins/rundeck-puppetenterprise-nodes-plugin/releases/download/v${version}/rundeck-puppetenterprise-nodes-plugin-${version}.jar",
    destination => '/var/lib/rundeck/libext/',
    timeout     => 0,
    verbose     => false,
  }

  $rundeck_access_user = $rundeck_user
  file { 'rundeck puppetdb node mapping':
    path    => '/etc/rundeck/defaultMapping.json',
    content => template($template),
    group   => $group,
    mode    => '0640',
    owner   => $user,
  }
}
