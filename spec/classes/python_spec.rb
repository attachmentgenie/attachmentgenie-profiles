require 'spec_helper'
describe 'profiles::python' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::python') }
  end
end
