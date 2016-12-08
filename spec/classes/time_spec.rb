require 'spec_helper'
describe 'profiles::time' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::time') }
      end
    end
  end
end
