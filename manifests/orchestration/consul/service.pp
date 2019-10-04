# This class can be used to create a consul service
#
# @example when declaring this class
#  ::profiles::orchestration::consul::service { 'foo': }
#
define profiles::orchestration::consul::service (
  Array[Hash] $checks = [],
  Stdlib::Port::Unprivileged $port = undef,
  String $service_name = $title,
  Array[String] $tags = [],
) {
  ::consul::service { $title:
    checks       => $checks,
    port         => $port,
    service_name => $service_name,
    tags         => $tags,
  }
}