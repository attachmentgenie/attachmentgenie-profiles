# This class can be used install nginx and web properties
#
# @example when declaring the nginx class
#  class { '::profiles::nginx': }
#
# @param upstreams (Hash) set(s) of upstream servers to use
# @param vhosts (Hash) set(s) of vhost to create
# @param vhost_packages (Hash) Packages to manage that contain vhosts files.
class profiles::nginx (
  $upstreams      = {},
  $vhosts         = {},
  $vhost_packages = {},
) {
  validate_hash(
    $upstreams,
    $vhosts,
    $vhost_packages
  )
  class { '::nginx': }

  create_resources( 'nginx::resource::upstream', $upstreams)
  $package_defaults = {
    ensure => present,
    tag    => 'do_a',
  }
  create_resources( 'package', $vhost_packages, $package_defaults )
  $vhost_defaults = {
    tag        => 'do_b',
  }
  create_resources( 'nginx::resource::server', $vhosts, $vhost_defaults)
  Package<| tag == 'do_a' |> -> Nginx::Resource::Upstream<| tag == 'do_b' |>
}
