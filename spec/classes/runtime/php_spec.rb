require 'spec_helper'
describe 'profiles::runtime::php' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { { 'fpm_pools' => { 'www' => {} } } }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::runtime::php') }
        it { is_expected.to contain_profiles__runtime__php__pool('www') }
        it { is_expected.to contain_php__fpm__pool('www').with_listen('127.0.0.1:9000') }
      end
    end
  end
end
