require 'spec_helper'
describe 'profiles::security::selinux' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(selinux_agent_vardir: '/var/lib/puppet')
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::security::selinux') }
      end
    end
  end
end
