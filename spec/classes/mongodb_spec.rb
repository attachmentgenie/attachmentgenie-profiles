require 'spec_helper'
describe 'profiles::mongodb' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :root_home => '/root',
        })
      end
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::mongodb') }
      end
    end
  end
end
