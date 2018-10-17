require 'spec_helper'
describe 'profiles::streaming::kafka' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(service_provider: 'systemd')
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::streaming::kafka') }
      end
    end
  end
end
