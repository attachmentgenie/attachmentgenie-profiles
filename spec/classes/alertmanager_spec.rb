require 'spec_helper'
describe 'profiles::alertmanager' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::alertmanager') }
  end
end
