require 'spec_helper'
describe 'profiles::monitoring::icinga2' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(
          icinga2_puppet_hostcert: '/var/lib/puppet/ssl/certs/host.example.org.pem',
          icinga2_puppet_hostprivkey: '/var/lib/puppet/ssl/private_keys/host.example.org.pem',
          icinga2_puppet_localcacert: '/var/lib/puppet/ssl/certs/ca.pem'
        )
      end
      let(:params) { { parent_endpoints: { 'icinga.example.org' => { host: '192.168.42.42' } } } }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::monitoring::icinga2') }
        it { is_expected.to contain_class('profiles::monitoring::icinga2::Params') }
        it { is_expected.to contain_package('nagios-plugins-all') }
        it { is_expected.to contain_icinga2__object__endpoint('icinga.example.org') }
        it { is_expected.to contain_icinga2__object__zone('global-templates') }
        it { is_expected.to contain_icinga2__object__zone('linux-commands') }
        it { is_expected.to contain_icinga2__object__zone('master') }
      end
    end
  end
end
