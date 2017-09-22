require 'spec_helper'
describe 'profiles::security' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::security') }
  end
end
