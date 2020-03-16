require 'spec_helper'
describe 'profiles::runtime::php' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::runtime::php') }
      end
    end
  end
end
