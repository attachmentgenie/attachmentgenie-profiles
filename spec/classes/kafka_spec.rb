require 'spec_helper'
describe 'profiles::kafka' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          service_provider: 'systemd',
        })
      end
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::kafka') }
      end
    end
  end
end
