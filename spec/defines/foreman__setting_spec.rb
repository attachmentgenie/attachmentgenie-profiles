require 'spec_helper'
describe 'profiles::puppet::foreman::setting' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with foo set to bar' do
        let(:title) { 'foo' }
        let(:params) { {:value => 'bar'} }
        it { should contain_foreman_config_entry('foo').with_value('bar') }
      end
    end
  end
end
