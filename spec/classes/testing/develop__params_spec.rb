require 'spec_helper'
describe 'profiles::testing::develop::params' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      context "It should not contain any resources" do
        it { should contain_class('profiles::testing::develop::params') }
        it { should have_resource_count(0) }
      end
    end
  end
end