require 'spec_helper'
describe 'profiles::kafka' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::kafka') }
  end
end
