require 'spec_helper'
describe 'profiles::testing::develop' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::testing::develop') }
        it { is_expected.to contain_package('git') }
      end
    end
  end
end
