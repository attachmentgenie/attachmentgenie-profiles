require 'spec_helper'
describe 'profiles::memcached' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::memcached') }
  end
end
