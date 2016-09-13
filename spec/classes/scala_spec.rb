require 'spec_helper'
describe 'profiles::scala' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::scala') }
  end
end
