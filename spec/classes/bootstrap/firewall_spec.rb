require 'spec_helper'
describe 'profiles::bootstrap::firewall' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::firewall') }
        it { is_expected.to contain_firewall('000 related,established').with_action('accept') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('000 related,established').with_action('accept') }
        it { is_expected.to contain_firewall('001 accept all icmp').with_action('accept') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('001 accept all icmp').with_action('accept') }
        it { is_expected.to contain_firewall('999 reject everything else').with_action('reject') }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('999 reject everything else').with_action('reject') }
      end
    end
  end
end
