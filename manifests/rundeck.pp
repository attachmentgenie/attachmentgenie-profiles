# This class can be used install rundeck components.
#
# @example when declaring the rundeck class
#  class { '::stacks::rundeck': }
#
# @param grails_server_url (String) External url.
# @param jvm_args (String) Additional rundeck jvm arguments.
# @param manage_repo (Boolean) Manage rpm repository.
# @param package (String) Package to install.
# @param projects (Hash) Projects to manage
class profiles::rundeck (
  $grails_server_url = "http://${::fqdn}",
  $jvm_args          = '-Dserver.http.host=127.0.0.1',
  $manage_repo       = false,
  $package           = present,
  $projects          = {},
) {
  validate_bool(
    $manage_repo,
  )
  validate_hash(
    $projects,
  )
  validate_string(
    $grails_server_url,
    $jvm_args,
    $package,
  )

  class { '::rundeck':
    grails_server_url => $grails_server_url,
    jvm_args          => $jvm_args,
    manage_repo       => $manage_repo,
    package_ensure    => $package,
  }
  create_resources(rundeck::config::project, $projects)
}