require 'spec_helper'
describe 'profiles::kubernetes::kubernetes' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::kubernetes::kubernetes') }
      end
    end
  end
end
