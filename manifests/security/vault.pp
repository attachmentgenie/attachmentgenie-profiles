# This class can be used install vault components.
#
# @example when declaring the vault class
#  class { '::profiles::security::vault': }
#
# @param package_name Only valid when the install_method == package. Defaults to `consul`.
class profiles::security::vault (
  Stdlib::Absolutepath $bin_dir           = '/usr/local/bin',
  String $config_dir                             = '/etc/vault.d',
  Boolean $enable_ui                              = true,
  Variant[Hash, Array[Hash]] $listener    = {
    'tcp' => {
      'address'         => '127.0.0.1:8200',
      'cluster_address' => '127.0.0.1:8201',
      'tls_disable'     => 1,
    },
  },
  Hash $extra_config                      = {
    'api_addr' => 'https://127.0.0.1:8200',
    'cluster_addr' => 'https://127.0.0.1:8201',
  },
  Enum['archive', 'repo'] $install_method = 'archive',
  Boolean $manage_firewall_entry          = true,
  Boolean $manage_package_repo            = false,
  Boolean $manage_sd_service              = false,
  Boolean $manage_storage_dir             = false,
  String[1] $package_name                 = 'vault',
  String $sd_service_check_interval       = '10s',
  Stdlib::HTTPUrl $sd_service_endpoint    = "http://${facts['networking']['ip']}:8200",
  String $sd_service_name                 = 'vault-ui',
  Array $sd_service_tags                  = ['metrics'],
  Hash $storage                           = { 'consul' => { 'address' => '127.0.0.1:8500', 'path' => 'vault/' } },
  Optional[Hash] $telemetry               = undef,
  String $version                         = '1.10.3',
) {
  if $install_method == 'archive' {
    if !defined(Package['unzip']) {
      package { 'unzip':
        ensure => present,
      }
    }
    Package['unzip'] -> Archive <||>
  }

  if $install_method == 'repo' {
    $_bin_dir = '/bin'
  } else {
    $_bin_dir = $bin_dir
  }

  class { 'vault':
    bin_dir             => $_bin_dir,
    config_dir          => $config_dir,
    enable_ui           => $enable_ui,
    extra_config        => $extra_config,
    install_method      => $install_method,
    listener            => $listener,
    manage_repo         => $manage_package_repo,
    manage_service_file => true,
    manage_storage_dir  => $manage_storage_dir,
    package_name        => $package_name,
    storage             => $storage,
    telemetry           => $telemetry,
    version             => $version,
  }

  if $manage_firewall_entry {
    profiles::bootstrap::firewall::entry { '200 allow vault UI and API':
      port => [8200],
    }
    profiles::bootstrap::firewall::entry { '200 allow vault cluster':
      port => [8201],
    }
  }
  if $manage_sd_service {
    ::profiles::orchestration::consul::service { $sd_service_name:
      checks => [
        {
          http     => $sd_service_endpoint,
          interval => $sd_service_check_interval,
        },
      ],
      port   => 8200,
      tags   => $sd_service_tags,
    }
  }
}
