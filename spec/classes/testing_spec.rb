require 'spec_helper'
describe 'profiles::testing' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::testing') }
  end
end
