require 'spec_helper'
describe 'profiles::metrics' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::metrics') }
  end
end
