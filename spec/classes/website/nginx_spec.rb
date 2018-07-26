require 'spec_helper'
describe 'profiles::website::nginx' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::website::nginx') }
        it { is_expected.to contain_firewall('200 allow HTTP and HTTPS').with_action('accept').with_dport([80,443]) }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('200 allow HTTP and HTTPS').with_action('accept').with_port([80,443]) }
      end
    end
  end
end
