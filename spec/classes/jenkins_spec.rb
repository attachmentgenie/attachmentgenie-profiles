require 'spec_helper'
describe 'profiles::jenkins' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::jenkins') }
  end
end
