require 'spec_helper'
describe 'profiles::dns::bind' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::dns::bind') }
        it { is_expected.to contain_package('bind') }
      end
    end
  end
end
