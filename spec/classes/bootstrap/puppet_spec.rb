require 'spec_helper'
describe 'profiles::bootstrap::puppet' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::puppet') }
        it { is_expected.to contain_file('csr_attributes.yaml').with_ensure('absent') }
      end
    end
  end
end
