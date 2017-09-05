require 'spec_helper'
describe 'profiles::orchestration::rundeck::puppetdb' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let :params do
        {
            version: '0.9.5',
        }
      end
      context "It should not contain any resources" do
        it { should contain_class('profiles::orchestration::rundeck::puppetdb') }
        it { should contain_wget__fetch('install puppetdb plugin') }
      end
    end
  end
end