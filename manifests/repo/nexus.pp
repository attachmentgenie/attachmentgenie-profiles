# This class can be used install nexus components.
#
# @example when declaring the nexus class
#  class { '::profiles::repo::nexus': }
#
class profiles::repo::nexus (

) {
  class{ '::nexus':
    version       => '3.18.1',
    revision      => '01',
    download_site => 'http://download.sonatype.com/nexus/3',
    nexus_type    => 'unix',
  }
}
