require 'spec_helper'
describe 'profiles::influxdb' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::influxdb') }
  end
end
