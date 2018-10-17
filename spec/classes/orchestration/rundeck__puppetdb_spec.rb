require 'spec_helper'
describe 'profiles::orchestration::rundeck::puppetdb' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let :params do
        {
          group: 'rundeck',
          template: 'profiles/defaultMapping.json.erb',
          rundeck_user: 'rundeck',
          version: '0.9.5',
          user: 'rundeck',
        }
      end

      context 'It should not contain any resources' do
        it { is_expected.to contain_class('profiles::orchestration::rundeck::puppetdb') }
        it { is_expected.to contain_file('rundeck puppetdb node mapping') }
        it { is_expected.to contain_wget__fetch('install puppetdb plugin') }
      end
    end
  end
end
