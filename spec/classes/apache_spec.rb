require 'spec_helper'
describe 'profiles::apache' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::apache') }
  end
end
