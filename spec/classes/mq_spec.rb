require 'spec_helper'
describe 'profiles::mq' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::mq') }
  end
end
