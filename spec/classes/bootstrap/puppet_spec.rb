require 'spec_helper'
describe 'profiles::bootstrap::puppet' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::bootstrap::puppet') }
        it { should contain_file('csr_attributes.yaml').with_ensure('absent') }
      end
    end
  end
end
