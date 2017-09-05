# Class to manage rundeck puppetdb integration.
#
# Dont include this class directly.
#
# @param version Version of the plugin to download and install
class profiles::orchestration::rundeck::puppetdb (
  String $version
) {
  wget::fetch { 'install puppetdb plugin':
    source      => "https://github.com/rundeck-plugins/rundeck-puppetenterprise-nodes-plugin/releases/download/v${version}/rundeck-puppetenterprise-nodes-plugin-${version}.jar",
    destination => '/var/lib/rundeck/libext/',
    timeout     => 0,
    verbose     => false,
  }
}
