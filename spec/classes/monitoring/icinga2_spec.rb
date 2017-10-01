require 'spec_helper'
describe 'profiles::monitoring::icinga2' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::monitoring::icinga2') }
      end
    end
  end
end
