require 'spec_helper'
describe 'profiles::collectd' do
  let :facts do
    {
        osfamily: 'RedHat',
        collectd_version: '5.5.0'
    }
  end

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::collectd') }
  end
end
