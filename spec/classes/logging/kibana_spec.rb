require 'spec_helper'
describe 'profiles::logging::kibana' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::logging::kibana') }
      end
    end
  end
end
