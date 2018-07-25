require 'spec_helper'
describe 'profiles::bootstrap::ssh' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::ssh') }
        it { is_expected.to contain_firewall('010 allow ssh').with_action('accept').with_dport(22) }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('010 allow ssh').with_action('accept').with_port(22) }
      end
    end
  end
end
