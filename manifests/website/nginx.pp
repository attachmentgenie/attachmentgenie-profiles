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
# @param daemon_user    User that runs nginx
# @param upstreams      Set(s) of upstream servers to use
# @param purge_configs   Purge unmanaged config files.
# @param stream         Enable streaming hosts.
# @param streams        Set(s) of streams.
# @param vhosts         Set(s) of vhost to create
# @param vhost_packages Packages to manage that contain vhosts files.
class profiles::website::nginx (
  String $daemon_user = 'nginx',
  Hash $upstreams = {},
  Boolean $purge_configs = true,
  Boolean $stream = false,
  Hash $streams = {},
  Hash $vhosts = {},
  Hash $vhost_packages = {},
) {
  class { '::nginx':
    confd_only        => true,
    confd_purge       => $purge_configs,
    daemon_user       => $daemon_user,
    nginx_cfg_prepend => { 'include' => ['/etc/nginx/modules-enabled/*.conf'] },
    server_purge      => $purge_configs,
    stream            => $stream,
  }

  $package_defaults = {
    ensure => present,
    tag    => 'do_a',
  }
  create_resources( 'package', $vhost_packages, $package_defaults )

  $resource_defaults = {
    tag        => 'do_b',
  }
  create_resources( 'nginx::resource::server', $vhosts, $resource_defaults )
  create_resources( 'nginx::resource::streamhost', $streams, $resource_defaults )
  create_resources( 'nginx::resource::upstream', $upstreams, $resource_defaults )

  Package<| tag == 'do_a' |> -> Nginx::Resource::Server<| tag == 'do_b' |>
  Package<| tag == 'do_a' |> -> Nginx::Resource::Streamhost<| tag == 'do_b' |>
  Package<| tag == 'do_a' |> -> Nginx::Resource::Upstream<| tag == 'do_b' |>

  profiles::bootstrap::firewall::entry { '200 allow HTTP and HTTPS':
    port => [80,443],
  }
}
