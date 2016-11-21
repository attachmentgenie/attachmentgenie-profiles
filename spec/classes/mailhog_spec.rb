require 'spec_helper'
describe 'profiles::mailhog' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::mailhog') }
  end
end
