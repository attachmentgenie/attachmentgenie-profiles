# This class can be used install rundeck components.
#
# @example when declaring the rundeck class
#  class { '::profiles::orchestration::rundeck': }
#
# @param auth_config       Authentication config.
# @param auth_types        The method(s) used to authenticate to rundeck.
# @param grails_server_url External url.
# @param group             Rundeck user.
# @param jvm_args          Additional rundeck jvm arguments.
# @param manage_repo       Manage rpm repository.
# @param package           Package to install.
# @param projects          Projects to manage
# @param puppetdb          Install puppetdb plugin
# @param puppetdb_template template to create mapping file.
# @param puppetdb_version  What version to install.
# @param rundeck_user      Username for the rundeck user.
# @param user              Rundeck user
class profiles::orchestration::rundeck (
  Hash $auth_config         = {
    'file' => {
      'admin_user'     => 'admin',
      'admin_password' => 'secret',
      'auth_users'     => {},
      'file'           => '/etc/rundeck/realm.properties',
    },
  },
  Array $auth_types         = ['file'],
  String $grails_server_url = "http://${::fqdn}",
  String $group             = 'rundeck',
  String $jvm_args          = '-Dserver.http.host=127.0.0.1',
  Boolean $manage_repo      = false,
  String $package           = '3.0.6',
  Hash $projects            = {},
  Boolean $puppetdb         = false,
  String $puppetdb_template = 'profiles/defaultMapping.json.erb',
  String $puppetdb_version  = '0.9.5',
  String $rundeck_user      = 'rundeck',
  String $user              = 'rundeck',
) {
  class { '::rundeck':
    auth_config       => $auth_config,
    auth_types        => $auth_types,
    grails_server_url => $grails_server_url,
    group             => $group,
    jvm_args          => $jvm_args,
    manage_repo       => $manage_repo,
    package_ensure    => $package,
    user              => $user,
  }
  create_resources(rundeck::config::project, $projects)

  if $puppetdb {
    class { 'profiles::orchestration::rundeck::puppetdb':
      group        => $group,
      template     => $puppetdb_template,
      rundeck_user => $rundeck_user,
      version      => $puppetdb_version,
      user         => $user,
    }
  }
}
