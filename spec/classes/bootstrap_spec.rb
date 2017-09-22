require 'spec_helper'
describe 'profiles::bootstrap' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::bootstrap') }
  end
end
