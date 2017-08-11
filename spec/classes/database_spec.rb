require 'spec_helper'
describe 'profiles::database' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::database') }
  end
end
