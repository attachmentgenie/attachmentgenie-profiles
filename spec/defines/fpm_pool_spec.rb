require 'spec_helper'
describe 'profiles::runtime::php::pool' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) { 'include profiles::runtime::php' }

      context 'with foo set to bar' do
        let(:title) { 'foo' }
        it { is_expected.to contain_php__fpm__pool('foo').with_listen('127.0.0.1:9000') }
      end
    end
  end
end
