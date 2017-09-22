require 'spec_helper'
describe 'profiles::logging' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::logging') }
  end
end
