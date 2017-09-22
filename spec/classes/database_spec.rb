require 'spec_helper'
describe 'profiles::database' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::database') }
  end
end
