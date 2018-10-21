require 'spec_helper'
describe 'profiles::metrics::grafana::datasource' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with foo set to bar' do
        let(:title) { 'influxdb' }
        let(:params) { { type: 'influxdb' } }

        it { is_expected.to contain_grafana_datasource('influxdb').with_type('influxdb') }
      end
    end
  end
end
