require 'spec_helper'
describe 'profiles::monitoring' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::monitoring') }
  end
end
