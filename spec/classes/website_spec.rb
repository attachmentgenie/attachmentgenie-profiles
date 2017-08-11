require 'spec_helper'
describe 'profiles::website' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::website') }
  end
end
