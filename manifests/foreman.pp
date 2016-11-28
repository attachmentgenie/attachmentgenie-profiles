# This class can be used install user foreman properties
#
# @example when declaring the apache class
#  class { '::profiles::foreman': }
#
# @param configure_epel_repo (Boolean) Configure epel repository
# @param custom_repo (Boolean) Inject your own foreman repo to configure.
# @param db_manage (Boolean) Manage the DB backend.
# @param foreman_admin_password (String) Foreman admin password.
# @param foreman_host (String) Foreman fqdn.
# @param foreman_repo (String) Foreman repo to use.
# @param locations_enabled (Boolean) Enable locations.
# @param organizations_enabled (Boolean) Enable organizations.
# @param passenger (Boolean) Run behind passenger.
# @param plugins (Hash) Foreman plugins to install.
# @param selinux (Boolean) Install foreman-selinux.
# @param ssl (Boolean) Enable ssl
# @param server_ssl_ca (String) SSL ca.
# @param server_ssl_chain (String) SSL chain.
# @param server_ssl_cert (String) SSL cert.
# @param server_ssl_key (String) SSL key.
# @param server_ssl_crl (String) SSL crl.
# @param unattended (Boolean) Allow unattended installs.
class profiles::foreman (
  $configure_epel_repo    = false,
  $custom_repo            = false,
  $db_manage              = true,
  $foreman_admin_password = 'secret',
  $foreman_host           = $::fqdn,
  $foreman_repo           = 'stable',
  $locations_enabled      = false,
  $organizations_enabled  = false,
  $passenger              = true,
  $plugins                = {},
  $selinux                = false,
  $ssl                    = true,
  $server_ssl_ca          = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  $server_ssl_chain       = '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
  $server_ssl_cert        = "/etc/puppetlabs/puppet/ssl/certs/${::fqdn}.pem",
  $server_ssl_key         = "/etc/puppetlabs/puppet/ssl/private_keys/${::fqdn}.pem",
  $server_ssl_crl         = '/etc/puppetlabs/puppet/ssl/ca/ca_crl.pem',
  $settings               = {},
  $unattended             = true,
) inherits profiles::foreman::params {
  class { '::foreman':
    admin_password        => $foreman_admin_password,
    authentication        => true,
    configure_epel_repo   => $configure_epel_repo,
    custom_repo           => $custom_repo,
    db_manage             => $db_manage,
    foreman_url           => $foreman_host,
    locations_enabled     => $locations_enabled,
    organizations_enabled => $organizations_enabled,
    passenger             => $passenger,
    selinux               => $selinux,
    ssl                   => $ssl,
    server_ssl_ca         => $server_ssl_ca,
    server_ssl_chain      => $server_ssl_chain,
    server_ssl_cert       => $server_ssl_cert,
    server_ssl_key        => $server_ssl_key,
    server_ssl_crl        => $server_ssl_crl,
    repo                  => $foreman_repo,
    unattended            => $unattended,
  }
  class { '::foreman::cli':
    foreman_url => $foreman_host,
    username    => 'admin',
    password    => $foreman_admin_password,
  }
  create_resources(::foreman::plugin, $plugins)
  create_resources(::profiles::foreman::setting, $settings)
}
