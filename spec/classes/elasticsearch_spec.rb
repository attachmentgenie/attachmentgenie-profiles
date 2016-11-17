require 'spec_helper'
describe 'profiles::elasticsearch' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::elasticsearch') }
  end
end
