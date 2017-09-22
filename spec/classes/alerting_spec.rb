require 'spec_helper'
describe 'profiles::alerting' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::alerting') }
  end
end
