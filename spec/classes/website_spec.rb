require 'spec_helper'
describe 'profiles::website' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::website') }
  end
end
