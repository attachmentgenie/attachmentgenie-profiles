require 'spec_helper'
describe 'profiles::security' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::security') }
  end
end
