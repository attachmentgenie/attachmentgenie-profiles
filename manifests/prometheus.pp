class profiles::prometheus (
  $prometheus_version = '1.0.1',
  $server             = false,
){
  if $server {
    class { '::prometheus':
      version => $prometheus_version,
    }
    include ::prometheus::alert_manager
  }

  include ::prometheus::node_exporter
}