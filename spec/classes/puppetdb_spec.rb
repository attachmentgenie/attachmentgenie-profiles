require 'spec_helper'
describe 'profiles::puppetdb' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::puppetdb') }
  end
end
