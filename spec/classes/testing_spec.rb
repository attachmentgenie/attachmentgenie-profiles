require 'spec_helper'
describe 'profiles::testing' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::testing') }
  end
end
