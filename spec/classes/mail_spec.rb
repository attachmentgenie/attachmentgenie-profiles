require 'spec_helper'
describe 'profiles::mail' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::mail') }
  end
end
