require 'spec_helper'
describe 'profiles::bootstrap::firewall' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::firewall') }
        it { is_expected.to contain_resources('firewall').with_purge(true) }
        it { is_expected.to contain_firewall('000 related,established').with_action('accept') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('000 related,established').with_action('accept') }
        it { is_expected.to contain_firewall('001 accept all icmp').with_action('accept') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('001 accept all icmp').with_action('accept') }
        it { is_expected.to contain_firewall('002 accept all to lo interface').with_iniface('lo').with_proto('all') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('002 accept all to lo interface').with_interface('lo').with_protocol('all') }
        it { is_expected.to contain_firewall('999 reject everything else').with_action('reject') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('999 reject everything else').with_action('reject') }
        it { is_expected.to contain_firewall('001 accept all icmp FORWARD').with_action('accept').with_chain('FORWARD') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('001 accept all icmp FORWARD').with_action('accept').with_chain('FORWARD') }
        it { is_expected.to contain_firewall('999 reject everything else FORWARD').with_action('reject').with_chain('FORWARD') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('999 reject everything else FORWARD').with_action('reject').with_chain('FORWARD') }
      end
    end
  end
end
