# This class can be used install user puppet properties
#
# @example when declaring the puppet class
#  class { '::profiles::bootstrap::puppet': }
#
# @param allow_any_crl_auth          Allow certificate signing by proxied requests.
# @param autosign                    Autosigning requests.
# @param autosign_domains            List of domains to trust while autosigning.
# @param dns_alt_names               List of additional dns names to sign into certificate.
# @param environment                 Environment for node.
# @param foreman_repo                Manage foreman repository,
# @param hiera_yaml_datadir (String) Hiera directory
# @param install_toml                Install toml gem.
# @param puppetmaster                Puppetmaster fqdn
# @param runmode                     How to run puppet
# @param runinterval                 Run interval.
# @param server                      Is this a puppetmaster.
# @param server_additional_settings  Additional settings
# @param server_ca                   Is this a CA.
# @param server_common_modules_path  List of module directories.
# @param server_environments         List of environments to support.
# @param server_external_nodes       Location of ENC script.
# @param server_foreman              Send reports to a foreman instance.
# @param server_foreman_url          foreman url.
# @param server_implementation       Puppet master type.
# @param server_jvm_max_heap_size    JVM max heap setting.
# @param server_jvm_min_heap_size    JVM min heap setting.
# @param server_passenger            Run puppetmaster behind passenger.
# @param server_parser               Puppet parser name.
# @param server_puppetdb_host        Puppetdb fqdn.
# @param server_reports              How to store reports.
# @param server_storeconfigs_backend Puppetdb version option.
# @param show_diff                   Show diff in puppet report.
# @param splay                       Start puppet at random time to spread load.
# @param splaylimit                  Splay with this timeframe.
# @param srv_domain                  domain to query.
# @param use_srv_records             Use srv records.
class profiles::bootstrap::puppet (
  Boolean $allow_any_crl_auth = true,
  Variant[Boolean, Stdlib::Absolutepath] $autosign = true,
  Array $autosign_domains = ['*.vagrant'],
  Array $dns_alt_names = [],
  String $environment = $::environment,
  Boolean $foreman_repo = false,
  String $hiera_yaml_datadir = '/var/lib/hiera',
  Boolean $install_toml = false,
  Optional[String] $puppetmaster ='puppet',
  String $runmode = 'service',
  Integer $runinterval = 1800,
  Boolean $server = false,
  Hash $server_additional_settings = {},
  Boolean $server_ca = true,
  Array $server_common_modules_path = [],
  Array $server_environments = [],
  String $server_external_nodes = '/etc/puppetlabs/puppet/node.rb',
  Boolean $server_foreman = false,
  String $server_foreman_url = 'http://foreman',
  String $server_implementation = 'puppetserver',
  String $server_jvm_max_heap_size = '512m',
  String $server_jvm_min_heap_size = '512m',
  Boolean $server_passenger = true,
  String $server_parser = 'current',
  Optional[String] $server_puppetdb_host = undef,
  String $server_reports = 'store',
  Optional[String] $server_storeconfigs_backend = undef,
  Boolean $show_diff = true,
  Boolean $splay = true,
  String $splaylimit = '1800s',
  String $srv_domain = 'example.org',
  Boolean $use_srv_records = false,
) {
  class { '::puppet':
    allow_any_crl_auth          => $allow_any_crl_auth,
    autosign                    => $autosign,
    autosign_entries            => $autosign_domains,
    dns_alt_names               => $dns_alt_names,
    environment                 => $environment,
    puppetmaster                => $puppetmaster,
    runmode                     => $runmode,
    runinterval                 => $runinterval,
    server                      => $server,
    server_additional_settings  => $server_additional_settings,
    server_ca                   => $server_ca,
    server_common_modules_path  => $server_common_modules_path,
    server_environments         => $server_environments,
    server_external_nodes       => $server_external_nodes,
    server_foreman              => $server_foreman,
    server_foreman_url          => $server_foreman_url,
    server_implementation       => $server_implementation,
    server_jvm_max_heap_size    => $server_jvm_max_heap_size,
    server_jvm_min_heap_size    => $server_jvm_min_heap_size,
    server_passenger            => $server_passenger,
    server_parser               => $server_parser,
    server_puppetdb_host        => $server_puppetdb_host,
    server_reports              => $server_reports,
    server_storeconfigs_backend => $server_storeconfigs_backend,
    show_diff                   => $show_diff,
    splay                       => $splay,
    splaylimit                  => $splaylimit,
    srv_domain                  => $srv_domain,
    use_srv_records             => $use_srv_records,
  }
  if $server {
    if versioncmp($::puppetversion, '4.0.0') <= 0 {
      file { 'hiera.yaml':
        mode    => '0644',
        owner   => 'puppet',
        group   => 'puppet',
        content => template('profiles/hiera.yaml.erb'),
        path    => '/etc/puppetlabs/puppet/hiera.yaml',
      }
      Class['::puppet']
      -> File['hiera.yaml']
    }

    if $foreman_repo {
      foreman::install::repos { 'foreman':
        repo     => 'stable',
      }
      Foreman::Install::Repos['foreman']
      -> Class['::puppet']
    }

    if $install_toml {
      package { 'toml-rb':
        ensure   => present,
        provider => puppetserver_gem,
        notify   => Service['puppetserver'],
      }
    }

    profiles::bootstrap::firewall::entry { '100 allow puppetmaster':
      port => 8140,
    }
  }

  file { 'csr_attributes.yaml':
    ensure => absent,
    backup => false,
    path   => "${settings::confdir}/csr_attributes.yaml",
  }
}
