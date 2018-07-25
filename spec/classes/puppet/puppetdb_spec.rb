require 'spec_helper'
describe 'profiles::puppet::puppetdb' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::puppet::puppetdb') }
        it { is_expected.to contain_firewall('100 allow puppetdb').with_action('accept').with_dport(8081) }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('100 allow puppetdb').with_action('accept').with_port(8081) }
      end
    end
  end
end
