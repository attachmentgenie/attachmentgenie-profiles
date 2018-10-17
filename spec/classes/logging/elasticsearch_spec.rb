require 'spec_helper'
describe 'profiles::logging::elasticsearch' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::logging::elasticsearch') }
        it { is_expected.to contain_elasticsearch__instance('foo.example.com') }
      end
    end
  end
end
