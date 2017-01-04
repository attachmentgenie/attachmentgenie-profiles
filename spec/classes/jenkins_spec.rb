require 'spec_helper'
describe 'profiles::jenkins' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          jenkins_plugins: '',
          systemd: true,
        })
      end
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::jenkins') }
      end
    end
  end
end
