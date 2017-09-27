# Class to manage rundeck puppetdb integration.
#
# Dont include this class directly.
#
# @param group    Rundeck user.
# @param template template to create mapping file.
# @param version  What version to install.
# @param user     Rundeck user
class profiles::orchestration::rundeck::puppetdb (
  $group,
  $template,
  $user,
  $version,
){
  wget::fetch { 'install puppetdb plugin':
    source      => "https://github.com/rundeck-plugins/rundeck-puppetenterprise-nodes-plugin/releases/download/v${version}/rundeck-puppetenterprise-nodes-plugin-${version}.jar",
    destination => '/var/lib/rundeck/libext/',
    timeout     => 0,
    verbose     => false,
  }

  $rundeck_access_user = $user
  file { 'rundeck puppetdb node mapping':
    path    => '/etc/rundeck/defaultMapping.json',
    content => template($template),
    group   => $group,
    mode    => '0640',
    owner   => $user,
  }
}
