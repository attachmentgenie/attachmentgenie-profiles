require 'spec_helper'
describe 'profiles::database::mysql' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(root_home: '/root')
      end
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::database::mysql') }
        it { is_expected.to contain_firewall('200 allow mysql').with_action('accept').with_dport(3306) }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('200 allow mysql').with_action('accept').with_port(3306) }
      end
    end
  end
end
