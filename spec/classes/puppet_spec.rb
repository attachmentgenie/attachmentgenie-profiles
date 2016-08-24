require 'spec_helper'
describe 'profiles::puppet' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::puppet') }
  end
end
