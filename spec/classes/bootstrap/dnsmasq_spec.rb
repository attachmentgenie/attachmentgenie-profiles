require 'spec_helper'
describe 'profiles::bootstrap::dnsmasq' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::bootstrap::dnsmasq') }
        it { is_expected.to contain_package('dnsmasq') }
      end
    end
  end
end
