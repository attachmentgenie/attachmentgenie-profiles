require 'spec_helper'
describe 'profiles::selinux' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :selinux_agent_vardir => '/var/lib/puppet',
        })
      end
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::selinux') }
      end
    end
  end
end
