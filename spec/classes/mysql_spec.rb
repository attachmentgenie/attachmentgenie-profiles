require 'spec_helper'
describe 'profiles::mysql' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) {
        facts.merge({
          :root_home => '/root',
        })
      }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::mysql') }
      end
    end
  end
end
