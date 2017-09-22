require 'spec_helper'
describe 'profiles::metrics' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::metrics') }
  end
end
