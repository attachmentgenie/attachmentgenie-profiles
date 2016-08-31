require 'spec_helper'
describe 'profiles::develop' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::develop') }
  end
end
