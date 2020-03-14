# This class can be used install jenkins components.
#
# @example when declaring the jenkins class
#  class { '::profiles::testing::jenkins': }
#
class profiles::testing::jenkins (
  Boolean $casc = true,
  Hash $casc_config = {},
  Hash $casc_config_default = {
    jenkins => {
      agentProtocols => [
        'JNLP4-connect',
        'Ping'
      ],
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
          users => [
            { id => 'admin', password => 'secret'},
            { id => 'slave', password => 'secret'},
          ]
        }
      },
      slaveAgentPort => 44444,
      systemMessage => "Jenkins configured automatically by Jenkins Configuration as Code plugin\n\n",
    },
    security => {
      globalJobDslSecurityConfiguration => {
        useScriptSecurity => false
      }
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
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  Boolean $manage_repo = false,
  Boolean $master = true,
  String $master_url = "http://${::fqdn}",
  Hash $plugins = {},
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
    matrix-project => {},
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
    swarm => {},
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
  String $sd_service_name = 'jenkins',
  Array $sd_service_tags = [],
  Boolean $slave = false,
  Boolean $slave_disable_ssl_verification = true,
  Integer $slave_executors = $::processors['count'],
  String $slave_user = 'slave',
  String $slave_password = 'secret',
  String $slave_version = '3.17',
) {
  if $master {
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
      cli                => false,
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

    create_resources(::jenkins::plugin, deep_merge($plugins_default, $plugins))

    if $manage_firewall_entry {
      ::profiles::bootstrap::firewall::entry { '200 allow jenkins':
        port => [$port],
      }

      ::profiles::bootstrap::firewall::entry { '200 allow jenkins slaves':
        port => [44444],
      }
    }
    if $manage_sd_service {
      ::profiles::orchestration::consul::service { $sd_service_name:
        checks => [
          {
            tcp      => "${listen_address}:8080",
            interval => '10s'
          }
        ],
        port   => 8080,
        tags   => $sd_service_tags,
      }
    }
  }

  if $slave {
    class { 'jenkins::slave':
      disable_ssl_verification => $slave_disable_ssl_verification,
      executors                => $slave_executors,
      install_java             => false,
      masterurl                => $master_url,
      ui_user                  => $slave_user,
      ui_pass                  => $slave_password,
      version                  => $slave_version,
    }
  }
}
