require 'spec_helper'
describe 'profiles::monitoring' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::monitoring') }
  end
end
