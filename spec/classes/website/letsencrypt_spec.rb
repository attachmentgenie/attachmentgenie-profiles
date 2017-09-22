require 'spec_helper'
describe 'profiles::website::letsencrypt' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(puppet_vardir: '/var/lib/puppet')
      end
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::website::letsencrypt') }
      end
    end
  end
end
