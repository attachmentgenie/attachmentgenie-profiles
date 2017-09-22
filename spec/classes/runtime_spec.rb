require 'spec_helper'
describe 'profiles::runtime' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::runtime') }
  end
end
