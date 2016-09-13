# This class can be used install scala components.
#
# @example when declaring the scala class
#  class { '::stacks::scala': }
#
# @param development (Boolean) Manage development packages on this node.
class profiles::scala (
  $development    = false,
) {
  package { 'scala':
    ensure   => present,
    provider => 'rpm',
    source   => 'http://downloads.lightbend.com/scala/2.11.8/scala-2.11.8.rpm',
  }
  if $development {
    yumrepo { 'bintray--sbt-rpm':
      descr    => 'bintray--sbt-rpm',
      baseurl  => 'http://dl.bintray.com/sbt/rpm',
      enabled  => 1,
      gpgcheck => 0,
    } ->
    package { 'sbt':
      ensure   => present,
    }
  }
}