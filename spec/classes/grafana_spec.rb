require 'spec_helper'
describe 'profiles::grafana' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::grafana') }
  end
end
