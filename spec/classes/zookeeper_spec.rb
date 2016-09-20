require 'spec_helper'
describe 'profiles::zookeeper' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::zookeeper') }
  end
end
