# This class can be used install user foreman properties
#
# @example when declaring the foreman class
#  class { '::profiles::puppet::foreman': }
#
# @param configure_epel_repo    Configure epel repository
# @param db_host                Db host.
# @param db_manage              Manage the DB backend.
# @param db_manage_rake         Manage the DB rake jobs.
# @param db_password            Db password.
# @param foreman_admin_password Foreman admin password.
# @param foreman_host           Foreman fqdn.
# @param foreman_repo           Foreman repo to use.
# @param locations_enabled      Enable locations.
# @param oauth_consumer_key     oauth_consumer_key.
# @param oauth_consumer_secret  oauth_consumer_secret.
# @param organizations_enabled  Enable organizations.
# @param passenger              Run behind passenger.
# @param plugins                Foreman plugins to install.
# @param protocol               Protocol to reach Foreman.
# @param selinux                Install foreman-selinux.
# @param server_ssl_ca          SSL ca.
# @param server_ssl_chain       SSL chain.
# @param server_ssl_cert        SSL cert.
# @param server_ssl_key         SSL key.
# @param server_ssl_crl         SSL crl.
# @param settings               List of foreman settings.
# @param unattended             Allow unattended installs.
# @param user_groups            List of groups for foreman user to join.
class profiles::puppet::foreman (
  Boolean $configure_epel_repo = false,
  String $db_host = 'localhost',
  Boolean $db_manage = false,
  Boolean $db_manage_rake = true,
  String $db_password = 'foreman',
  String $foreman_admin_password = 'secret',
  String $foreman_host  = $::fqdn,
  String $foreman_repo = '1.22',
  String $oauth_consumer_key = 'secret',
  String $oauth_consumer_secret = 'secret',
  Boolean $passenger = true,
  Hash $plugins = {},
  Enum['http','https'] $protocol = 'https',
  Boolean $selinux = false,
  String $server_ssl_ca = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  String $server_ssl_chain = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  String $server_ssl_cert = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
  String $server_ssl_key = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
  String $server_ssl_crl = '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem',
  Hash $settings = {},
  Boolean $unattended = true,
  Array $user_groups = ['puppet'],
) inherits profiles::puppet::foreman::params {
  if $protocol == 'https' {
    $ssl  = true
  } else {
    $ssl  = false
  }
  class { '::foreman':
    configure_epel_repo    => $configure_epel_repo,
    db_host                => $db_host,
    db_manage              => $db_manage,
    db_manage_rake         => $db_manage_rake,
    db_password            => $db_password,
    foreman_url            => "${protocol}://${foreman_host}",
    initial_admin_password => $foreman_admin_password,
    oauth_consumer_key     => $oauth_consumer_key,
    oauth_consumer_secret  => $oauth_consumer_secret,
    passenger              => $passenger,
    selinux                => $selinux,
    ssl                    => $ssl,
    server_ssl_ca          => $server_ssl_ca,
    server_ssl_chain       => $server_ssl_chain,
    server_ssl_cert        => $server_ssl_cert,
    server_ssl_key         => $server_ssl_key,
    server_ssl_crl         => $server_ssl_crl,
    repo                   => $foreman_repo,
    unattended             => $unattended,
    user_groups            => $user_groups,
  }
  class { '::foreman::cli':
    foreman_url => "${protocol}://${foreman_host}",
    username    => 'admin',
    password    => $foreman_admin_password,
  }
  create_resources(::foreman::plugin, $plugins)
  $settings_defaults = {
    tag    => 'do_a',
  }
  create_resources(::profiles::puppet::foreman::setting, $settings, $settings_defaults)

  if $passenger {
    Class['apache::service'] -> Foreman_config_entry <| tag == 'do_a' |>
  }

  Foreman::Repos::Yum[foreman] -> Package[foreman-proxy]
}
