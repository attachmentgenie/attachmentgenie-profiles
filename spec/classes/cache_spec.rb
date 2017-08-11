require 'spec_helper'
describe 'profiles::cache' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::cache') }
  end
end
