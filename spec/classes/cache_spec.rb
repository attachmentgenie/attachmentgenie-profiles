require 'spec_helper'
describe 'profiles::cache' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::cache') }
  end
end
