require 'spec_helper'
describe 'profiles::bootstrap' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::bootstrap') }
  end
end
