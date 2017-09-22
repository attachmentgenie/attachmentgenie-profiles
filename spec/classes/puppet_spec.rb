require 'spec_helper'
describe 'profiles::puppet' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::puppet') }
  end
end
