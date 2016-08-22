require 'spec_helper'
describe 'profiles::java' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::java') }
  end
end
