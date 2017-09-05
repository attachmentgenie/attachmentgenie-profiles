require 'spec_helper'
describe 'profiles::logging::elasticsearch' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context 'with defaults for all parameters' do
        it { should contain_class('profiles::logging::elasticsearch') }
        it { should contain_elasticsearch__instance('foo.example.com') }
      end
    end
  end
end
