require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :architecture              => 'amd64',
    :ipaddress                 => '127.0.0.1',
    :ipaddress_eth0            => '192.168.42.42',
    :ipaddress_eth1            => '192.168.42.43',
    :is_virtual                => true,
    :kernel                    => 'linux',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'CentOS',
    :operatingsystemrelease    => '7.2,',
    :operatingsystemmajrelease => '7',
    :os_maj_release            => '7',
    :path                      => '/usr/bin',
    :processorcount            => 2,
    :puppetversion             => '3.8.7',
    :selinux                   => 'true',
    :staging_http_get          => 'curl',
  }
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
