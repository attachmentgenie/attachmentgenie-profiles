require 'spec_helper'
describe 'profiles::bootstrap::firewall' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::firewall') }
        it { is_expected.to contain_resources('firewall').with_purge(true) }
      end
    end
  end
end
