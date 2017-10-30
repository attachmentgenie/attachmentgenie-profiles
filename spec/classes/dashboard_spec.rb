require 'spec_helper'
describe 'profiles::dashboard' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::dashboard') }
  end
end
