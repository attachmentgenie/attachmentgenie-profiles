# This class can be used install nginx and web properties
#
# @example when declaring the nginx class
#  class { '::profiles::nginx': }
#
# @params upstreams (Hash) set(s) of upstream servers to use
# @params vhosts (Hash) set(s) of vhost to create
class profiles::nginx (
  $upstreams = {},
  $vhosts = {},
) {
  class { 'nginx': }

  create_resources( 'nginx::resource::upstream', $upstreams)
  create_resources( 'nginx::resource::vhost', $vhosts)
}
