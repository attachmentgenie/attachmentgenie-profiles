require 'spec_helper'
describe 'profiles::orchestration::consul' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::orchestration::consul') }
        it { should contain_package('unzip') }
      end
    end
  end
end
