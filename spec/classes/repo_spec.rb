require 'spec_helper'
describe 'profiles::repo' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::repo') }
  end
end
