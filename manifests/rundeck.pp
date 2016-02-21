#
class profiles::rundeck (
  $motd          = false,
  $puppetdb_host = puppet,
  $puppetdb_port = 8080,
) {

  class { '::rundeck': }
  class { '::puppetdb_rundeck':
    puppetdb_host => $puppetdb_host,
    puppetdb_port => $puppetdb_port,
  }

  rundeck::config::project { 'Platform project':
    file_copier_provider   => 'jsch-scp',
    node_executor_provider => 'jsch-ssh',
    resource_sources       => {
      platform => { project_name        => 'Platform',
                    source_type         => 'url',
                    url                 => 'http://localhost:4567/api/yaml',
                    include_server_node => true,
                    resource_format     => 'resourceyaml',
                  }
    },
    framework_config       => {
      'framework.ssh.keypath' => '/opt/orchestrate/id_rsa',
      'framework.ssh.user'    => 'orchestrate',
      'framework.ssh.timeout' => '0',
    },
  }
  accounts::account { '@rundeck': }

  if $motd {
    motd::register{ 'Profile : rundeck': }
  }
}