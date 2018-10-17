require 'spec_helper'
describe 'profiles::website::uwsgi' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::website::uwsgi') }
        it { is_expected.to contain_group('uwgsi').with_ensure('present') }
        it { is_expected.to contain_user('uwgsi').with_ensure('present') }
      end
    end
  end
end
