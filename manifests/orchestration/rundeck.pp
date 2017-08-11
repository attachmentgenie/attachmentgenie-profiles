# This class can be used install rundeck components.
#
# @example when declaring the rundeck class
#  class { '::profiles::orchestration::rundeck': }
#
# @param grails_server_url External url.
# @param jvm_args          Additional rundeck jvm arguments.
# @param manage_repo       Manage rpm repository.
# @param package           Package to install.
# @param projects          Projects to manage
class profiles::orchestration::rundeck (
  String $grails_server_url = "http://${::fqdn}",
  String $jvm_args          = '-Dserver.http.host=127.0.0.1',
  Boolean $manage_repo      = false,
  String $package           = '2.9.3',
  Hash $projects            = {},
) {
  class { '::rundeck':
    grails_server_url => $grails_server_url,
    jvm_args          => $jvm_args,
    manage_repo       => $manage_repo,
    package_ensure    => $package,
  }
  create_resources(rundeck::config::project, $projects)
}
