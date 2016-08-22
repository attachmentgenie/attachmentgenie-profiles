require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.default_facts = {
    :ipaddress                 => '127.0.0.1',
    :ipaddress_eth1            => '127.0.0.1',
    :is_virtual                => true,
    :kernel                    => 'linux',
    :osfamily                  => 'RedHat',
    :operatingsystem           => 'centos',
    :operatingsystemrelease    => '7.2,',
    :operatingsystemmajrelease => '7',
    :os_maj_release            => '7',
    :path                      => '/usr/bin',
    :processorcount            => 2,
    :puppetversion             => '3.8.7',
    :selinux                   => 'true',
  }
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
