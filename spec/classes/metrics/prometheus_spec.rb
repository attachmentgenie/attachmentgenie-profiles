require 'spec_helper'
describe 'profiles::metrics::prometheus' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(staging_http_get: 'curl')
      end
      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::metrics::prometheus') }
      end
    end
  end
end
