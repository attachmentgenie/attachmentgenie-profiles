require 'spec_helper'
describe 'profiles::runtime' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::runtime') }
  end
end
