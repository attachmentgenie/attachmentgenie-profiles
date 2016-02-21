class profiles::mcollective_r10k (
  $agent_path = '/usr/lib/ruby/site_ruby/1.8/mcollective/agent',
  $app_path   = '/usr/lib/ruby/site_ruby/1.8/mcollective/application',
) {
  class { '::r10k::mcollective':
    agent_path => $agent_path,
    app_path   => $app_path,
  }
}