require 'spec_helper'
describe 'profiles::monitoring::prometheus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(staging_http_get: 'curl')
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::monitoring::prometheus') }
      end
    end
  end
end
