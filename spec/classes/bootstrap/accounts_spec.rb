require 'spec_helper'
describe 'profiles::bootstrap::accounts' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::accounts') }
      end
    end
  end
end
