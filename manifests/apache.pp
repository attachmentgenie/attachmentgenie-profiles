class profiles::apache (
  $vhosts = {  "${::fqdn}" => {
      proxy_dest => 'http://127.0.0.1:3000'
    },
  }
) {

  include ::apache

  $vhost_defaults = {
    vhost_name     => '*',
    docroot        => '/var/www',
    error_log      => true,
  }
  create_resources( 'apache::vhost', $vhosts, $vhost_defaults )
}