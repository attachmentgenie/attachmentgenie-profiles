require 'spec_helper'
describe 'profiles::website::haproxy' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::website::haproxy') }
      end
    end
  end
end
