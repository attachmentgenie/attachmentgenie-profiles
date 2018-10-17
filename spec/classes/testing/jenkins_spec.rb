require 'spec_helper'
describe 'profiles::testing::jenkins' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(jenkins_plugins: '',
                    systemd: true)
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::testing::jenkins') }
      end
    end
  end
end
