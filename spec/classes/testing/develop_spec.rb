require 'spec_helper'
describe 'profiles::testing::develop' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::testing::develop') }
        it { should contain_package('git') }
      end
    end
  end
end
