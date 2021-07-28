# Class: profiles::website::nginx
#
# This class can be used install nginx and web properties
#
# === Examples
#
# @example when declaring the nginx class
#  class { '::profiles::website::nginx': }
#
# === Parameters
#
# @param client_body_buffer_size Sets buffer size for reading client request body.
# @param client_max_body_size    Sets the maximum allowed size of the client request body.
# @param daemon_user             User that runs nginx
# @param upstreams               Set(s) of upstream servers to use
# @param purge_configs           Purge unmanaged config files.
# @param stream                  Enable streaming hosts.
# @param streams                 Set(s) of streams.
# @param vhosts                  Set(s) of vhost to create
# @param vhost_packages          Packages to manage that contain vhosts files.
# @param upstream_defined_type   Boolean to directly use the upstream nginx server type.
class profiles::website::nginx (
  String $client_body_buffer_size = '1k',
  String $client_max_body_size = '1k',
  String $daemon_user = 'nginx',
  Hash $upstreams = {},
  Hash $proxies = {},
  Boolean $purge_configs = true,
  Boolean $stream = false,
  Hash $streams = {},
  Hash $vhosts = {},
  Hash $vhost_packages = {},
  Boolean $upstream_defined_type = false,
) {
  class { '::nginx':
    client_body_buffer_size => $client_body_buffer_size,
    client_max_body_size    => $client_max_body_size,
    confd_only              => true,
    confd_purge             => $purge_configs,
    daemon_user             => $daemon_user,
    global_mode             => '0600',
    nginx_cfg_prepend       => { 'include' => ['/etc/nginx/modules-enabled/*.conf'] },
    server_purge            => $purge_configs,
    server_tokens           => 'off',
    stream                  => $stream,
  }

  $package_defaults = {
    ensure => present,
    tag    => 'do_a',
  }
  create_resources( 'package', $vhost_packages, $package_defaults )

  $resource_defaults = {
    tag        => 'do_b',
  }

  if $upstream_defined_type {
    create_resources( 'nginx::resource::server', $vhosts, $resource_defaults )
    Package<| tag == 'do_a' |> -> Nginx::Resource::Server<| tag == 'do_b' |>
    create_resources( 'nginx::resource::server', $proxies, $resource_defaults )
    Package<| tag == 'do_a' |> -> Nginx::Resource::Server<| tag == 'do_b' |>
  } else {
    create_resources( '::profiles::website::nginx::vhost', $vhosts, $resource_defaults )
    Package<| tag == 'do_a' |> -> ::Profiles::Website::Nginx::Vhost<| tag == 'do_b' |>
    create_resources( '::profiles::website::nginx::proxy', $proxies, $resource_defaults )
    Package<| tag == 'do_a' |> -> ::Profiles::Website::Nginx::Proxy<| tag == 'do_b' |>
  }

  create_resources( 'nginx::resource::streamhost', $streams, $resource_defaults )
  create_resources( 'nginx::resource::upstream', $upstreams, $resource_defaults )
  Package<| tag == 'do_a' |> -> Nginx::Resource::Streamhost<| tag == 'do_b' |>
  Package<| tag == 'do_a' |> -> Nginx::Resource::Upstream<| tag == 'do_b' |>

  profiles::bootstrap::firewall::entry { '200 allow HTTP and HTTPS NGINX':
    port => [80,443],
  }
}
