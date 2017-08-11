require 'spec_helper'
describe 'profiles::alerting' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::alerting') }
  end
end
