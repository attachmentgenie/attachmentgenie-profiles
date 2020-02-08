# This class can be used install jenkins components.
#
# @example when declaring the jenkins class
#  class { '::profiles::jenkins': }
#
class profiles::testing::jenkins (
  Boolean $casc = true,
  Hash $casc_config = {},
  Hash $casc_config_default = {
    jenkins => {
      authorizationStrategy => {
        loggedInUsersCanDoAnything => {
          allowAnonymousRead => false
        }
      },
      crumbIssuer => {
        standard => {
          excludeClientIPFromCrumb => true
        }
      },
      disableRememberMe => true,
      numExecutors  => $::processors['count'],
      remotingSecurity => {
        enabled => true
      },
      securityRealm => {
        local => {
          allowsSignup => false,
          enableCaptcha => false,
          users => [{ id => 'admin', password => 'secret'}]
        }
      },
      systemMessage => "Jenkins configured automatically by Jenkins Configuration as Code plugin\n\n",
    },
    unclassified => {
      location => {
        url => "http://${::fqdn}",
      }
    }
  },
  String $casc_reload_token = 'supersecret',
  Hash $config_hash = {},
  String $java_options = '-Djava.awt.headless=true -Djenkins.install.runSetupWizard=false',
  Stdlib::Host $listen_address = '127.0.0.1',
  Boolean $lts = true,
  Boolean $manage_firewall_entry = false,
  Boolean $manage_repo = false,
  Hash $plugins = {},
  Hash $plugins_casc = {},
  Hash $plugins_default = {
    ace-editor => {},
    antisamy-markup-formatter => {},
    apache-httpcomponents-client-4-api => {},
    authentication-tokens => {},
    bouncycastle-api => {},
    branch-api => {},
    configuration-as-code => {},
    command-launcher => {},
    cloudbees-folder => {},
    conditional-buildstep => {},
    credentials => {},
    credentials-binding => {},
    delivery-pipeline-plugin => {},
    docker-commons => {},
    docker-workflow => {},
    display-url-api => {},
    durable-task => {},
    external-monitor-job => {},
    git => {},
    git-client => {},
    git-server => {},
    handlebars => {},
    jdk-tool => {},
    job-dsl => {},
    jackson2-api => {},
    javadoc => {},
    jaxb => {},
    jsch => {},
    jquery => {},
    jquery-detached => {},
    junit => {},
    ldap => {},
    lockable-resources => {},
    mailer => {},
    matrix-auth => {},
    maven-plugin => {},
    modernstatus => {},
    momentjs => {},
    pam-auth => {},
    parameterized-trigger => {},
    pipeline-build-step => {},
    pipeline-graph-analysis => {},
    pipeline-input-step => {},
    pipeline-milestone-step => {},
    pipeline-model-api => {},
    pipeline-model-declarative-agent => {},
    pipeline-model-definition => {},
    pipeline-model-extensions => {},
    pipeline-rest-api => {},
    pipeline-stage-step => {},
    pipeline-stage-tags-metadata => {},
    pipeline-stage-view => {},
    plain-credentials  => {},
    run-condition => {},
    scm-api => {},
    script-security => {},
    ssh-credentials => {},
    structs => {},
    token-macro => {},
    trilead-api => {},
    windows-slaves => {},
    workflow-aggregator => {},
    workflow-api => {},
    workflow-basic-steps => {},
    workflow-cps => {},
    workflow-cps-global-lib => {},
    workflow-durable-task-step => {},
    workflow-job => {},
    workflow-multibranch => {},
    workflow-scm-step => {},
    workflow-step-api => {},
    workflow-support => {},
  },
  Stdlib::Port::Unprivileged $port = 8080,
  Boolean $purge_plugins = true,
) {
  if $casc {
    $_casc_java_args = {
      'JENKINS_JAVA_OPTIONS' => { value => "${java_options} -Dcasc.reload.token=${casc_reload_token}" },
    }
  } else {
    $_casc_java_args = {
      'JENKINS_JAVA_OPTIONS' => { value => $java_options },
    }
  }

  $_listen_config = {
    'JENKINS_LISTEN_ADDRESS' => { 'value' => $listen_address },
    'JENKINS_PORT' => { 'value' => "${port}" },  # lint:ignore:only_variable_string
  }

  class { '::jenkins':
    cli_remoting_free  => false,
    config_hash        => deep_merge($config_hash, $_listen_config, $_casc_java_args),
    configure_firewall => false,
    default_plugins    => [],
    install_java       => false,
    lts                => $lts,
    purge_plugins      => $purge_plugins,
    repo               => $manage_repo,
  }
  if $casc {
    $_casc_config = deep_merge($casc_config_default, $casc_config)

    file { "${::jenkins::localstatedir}/jenkins.yaml":
      content => template('profiles/testing/jenkins/jenkins.yaml.erb'),
      group   => $::jenkins::group,
      owner   => $::jenkins::user,
      before  => Service[jenkins],
    }

    exec { 'jenkins casc reload':
      command     => "curl -XPOST http://${listen_address}:${port}/reload-configuration-as-code/?casc-reload-token=${casc_reload_token}",
      path        => '/bin:/usr/bin',
      subscribe   => File["${::jenkins::localstatedir}/jenkins.yaml"],
      refreshonly => true,
      require     => Service[jenkins],
      tries       => 3,
      try_sleep   => 10,
    }
  }

  create_resources(::jenkins::plugin, deep_merge($plugins_default, $plugins_casc, $plugins))

  if $manage_firewall_entry {
    ::profiles::bootstrap::firewall::entry { '200 allow jenkins':
      port => [$port],
    }
  }
}
