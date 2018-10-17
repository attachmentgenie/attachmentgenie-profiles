require 'spec_helper'
describe 'profiles::puppet::foreman::params' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'It should not contain any resources' do
        it { is_expected.to contain_class('profiles::puppet::foreman::params') }
        it { is_expected.to have_resource_count(0) }
      end
    end
  end
end
