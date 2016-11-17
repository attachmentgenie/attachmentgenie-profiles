require 'spec_helper'
describe 'profiles::kibana' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::kibana') }
  end
end
