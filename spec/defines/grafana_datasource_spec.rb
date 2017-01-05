require 'spec_helper'
describe 'profiles::grafana::datasource' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with foo set to bar' do
        let(:title) { 'influxdb' }
        let(:params) { {:type => 'influxdb'} }
        it { should contain_grafana_datasource('influxdb').with_type('influxdb') }
      end
    end
  end
end
