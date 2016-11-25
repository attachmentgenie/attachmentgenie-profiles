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
