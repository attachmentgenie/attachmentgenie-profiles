require 'spec_helper'
describe 'profiles::prometheus' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::prometheus') }
  end
end
