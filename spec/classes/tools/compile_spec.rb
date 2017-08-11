require 'spec_helper'
describe 'profiles::tools::compile' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::tools::compile') }
      end
    end
  end
end
