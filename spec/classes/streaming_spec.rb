require 'spec_helper'
describe 'profiles::streaming' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::streaming') }
  end
end
