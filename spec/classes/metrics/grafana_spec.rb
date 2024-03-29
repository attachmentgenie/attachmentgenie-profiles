require 'spec_helper'
describe 'profiles::metrics::grafana' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { { 'manage_database' => false } }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::metrics::grafana') }
      end
    end
  end
end
