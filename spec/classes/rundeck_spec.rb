require 'spec_helper'
describe 'profiles::rundeck' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::rundeck') }
  end
end
