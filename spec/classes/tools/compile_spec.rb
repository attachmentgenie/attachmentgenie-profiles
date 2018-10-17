require 'spec_helper'
describe 'profiles::tools::compile' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::tools::compile') }
      end
    end
  end
end
