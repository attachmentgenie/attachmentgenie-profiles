require 'spec_helper'
describe 'profiles::website::nginx::vhost' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) { 'include profiles::website::nginx' }

      context 'with foo set to bar' do
        let(:title) { 'foo.bar' }
        let(:params) { { www_root: '/usr/share/nginx/html' } }

        it { is_expected.to contain_nginx__resource__server('foo.bar').with_www_root('/usr/share/nginx/html') }
      end
    end
  end
end
