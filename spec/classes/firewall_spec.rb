require 'spec_helper'
describe 'profiles::firewall' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::firewall') }
  end
end
