require 'spec_helper'
describe 'profiles::mail' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::mail') }
  end
end
