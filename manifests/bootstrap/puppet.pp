# This class can be used install user puppet properties
#
# @example when declaring the puppet class
#  class { '::profiles::bootstrap::puppet': }
#
# @param allow_any_crl_auth          Allow certificate signing by proxied requests.
# @param autosign                    Autosigning requests.
# @param autosign_domains            List of domains to trust while autosigning.
# @param autosign_mode               mode of the autosign file/script
# @param ca_server                   Use a different ca server.
# @param dns_alt_names               List of additional dns names to sign into certificate.
# @param environment                 Environment for node.
# @param foreman_repo                Manage foreman repository,
# @param hiera_yaml_datadir (String) Hiera directory
# @param install_toml                Install toml gem.
# @param install_vault               Install toml gem.
# @param puppetmaster                Puppetmaster fqdn
# @param purge_csr_attributes        Cleanup the purge_csr_attributes.yaml file.
# @param runmode                     How to run puppet
# @param runinterval                 Run interval.
# @param server                      Is this a puppetmaster.
# @param server_additional_settings  Additional settings
# @param server_ca                   Is this a CA.
# @param server_common_modules_path  List of module directories.
# @param server_external_nodes       Location of ENC script.
# @param server_foreman              Send reports to a foreman instance.
# @param server_foreman_url          foreman url.
# @param server_jvm_max_heap_size    JVM max heap setting.
# @param server_jvm_min_heap_size    JVM min heap setting.
# @param server_parser               Puppet parser name.
# @param server_puppetdb_host        Puppetdb fqdn.
# @param server_reports              How to store reports.
# @param show_diff                   Show diff in puppet report.
# @param splay                       Start puppet at random time to spread load.
# @param splaylimit                  Splay with this timeframe.
# @param srv_domain                  domain to query.
# @param use_srv_records             Use srv records.
class profiles::bootstrap::puppet (
  Boolean $allow_any_crl_auth = true,
  Variant[Boolean, Stdlib::Absolutepath] $autosign = true,
  Array $autosign_domains = ['*.vagrant'],
  Pattern[/^[0-9]{3,4}$/] $autosign_mode = '0664',
  Variant[String, Boolean] $ca_server = false,
  Boolean $deploy_gc_collect_puppetdb = false,
  Array $dns_alt_names = [],
  String $environment = $facts['environment'],
  Boolean $foreman_repo = false,
  String $hiera_yaml_datadir = '/var/lib/hiera',
  Boolean $install_toml = false,
  Boolean $install_vault = false,
  Boolean $manage_firewall_entry = true,
  Boolean $manage_sd_service = false,
  String $puppetmaster ='puppet',
  Boolean $purge_csr_attributes = true,
  String $runmode = 'service',
  Integer $runinterval = 1800,
  String $sd_service_name = 'puppet',
  Array $sd_service_tags = [],
  Boolean $server = false,
  Hash $server_additional_settings = {},
  Boolean $server_ca = true,
  Array $server_common_modules_path = [],
  String $server_external_nodes = '/etc/puppetlabs/puppet/node.rb',
  Boolean $server_foreman = false,
  String $server_foreman_url = 'http://foreman',
  Optional[Stdlib::Host] $server_graphite_host = undef,
  Optional[Stdlib::Port::Unprivileged] $server_graphite_port = undef,
  String $server_jvm_max_heap_size = '512m',
  String $server_jvm_min_heap_size = '512m',
  String $server_parser = 'current',
  Optional[String] $server_puppetdb_host = undef,
  String $server_reports = 'store',
  Boolean $server_ship_metrics = false,
  Boolean $server_storeconfigs = false,
  Boolean $show_diff = true,
  Boolean $splay = true,
  String $splaylimit = '1800s',
  String $srv_domain = 'example.org',
  Boolean $use_cache_on_failure = false,
  Boolean $use_srv_records = false,
) {
  class { 'puppet':
    agent_server_hostname          => $puppetmaster,
    allow_any_crl_auth             => $allow_any_crl_auth,
    autosign                       => $autosign,
    autosign_entries               => $autosign_domains,
    autosign_mode                  => $autosign_mode,
    ca_server                      => $ca_server,
    dns_alt_names                  => $dns_alt_names,
    environment                    => $environment,
    runmode                        => $runmode,
    runinterval                    => $runinterval,
    server                         => $server,
    server_additional_settings     => $server_additional_settings,
    server_ca                      => $server_ca,
    server_common_modules_path     => $server_common_modules_path,
    server_external_nodes          => $server_external_nodes,
    server_foreman                 => $server_foreman,
    server_foreman_url             => $server_foreman_url,
    server_metrics_graphite_enable => $server_ship_metrics,
    server_metrics_graphite_host   => $server_graphite_host,
    server_metrics_graphite_port   => $server_graphite_port,
    server_jvm_max_heap_size       => $server_jvm_max_heap_size,
    server_jvm_min_heap_size       => $server_jvm_min_heap_size,
    server_parser                  => $server_parser,
    server_reports                 => $server_reports,
    server_storeconfigs            => $server_storeconfigs,
    show_diff                      => $show_diff,
    splay                          => $splay,
    splaylimit                     => $splaylimit,
    srv_domain                     => $srv_domain,
    usecacheonfailure              => $use_cache_on_failure,
    use_srv_records                => $use_srv_records,
  }
  if $server {
    if versioncmp($facts['puppetversion'], '4.0.0') <= 0 {
      file { 'hiera.yaml':
        mode    => '0644',
        owner   => 'puppet',
        group   => 'puppet',
        content => template('profiles/hiera.yaml.erb'),
        path    => '/etc/puppetlabs/puppet/hiera.yaml',
      }
      Class['puppet']
      -> File['hiera.yaml']
    }

    if $server_puppetdb_host {
      class { 'puppet::server::puppetdb':
        server => $server_puppetdb_host,
      }
    }

    if $foreman_repo {
      foreman::install::repos { 'foreman':
        repo     => 'stable',
      }
      Foreman::Install::Repos['foreman']
      -> Class['puppet']
    }

    if $install_toml {
      package { 'toml-rb':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    if $install_vault {
      package { 'hiera-vault':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    if $manage_firewall_entry {
      profiles::bootstrap::firewall::entry { '100 allow puppetmaster':
        port => 8140,
      }
    }
    if $manage_sd_service {
      ::profiles::orchestration::consul::service { $sd_service_name:
        checks => [
          {
            tcp      => "${facts['networking']['ip']}:8140",
            interval => '10s'
          },
        ],
        port   => 8140,
        tags   => $sd_service_tags,
      }
    }
  }

  if $purge_csr_attributes {
    file { 'csr_attributes.yaml':
      ensure => absent,
      backup => false,
      path   => "${settings::confdir}/csr_attributes.yaml",
    }
  }

  if $deploy_gc_collect_puppetdb {
    file { 'gc_collect_puppetdb':
      mode   => '0755',
      owner  => 'puppet',
      group  => 'puppet',
      source => "puppet:///modules/${module_name}/bootstrap/gc_collect_puppetdb",
      path   => '/opt/puppetlabs/bin/gc_collect_puppetdb',
    }
  }
}
