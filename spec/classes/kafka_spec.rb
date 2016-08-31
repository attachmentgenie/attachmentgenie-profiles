require 'spec_helper'
describe 'profiles::kafka' do

  context 'with defaults for all parameters' do
    let(:params) { {:zookeeper_connect => ['zookeeper.foo.bar']} }
    it { should contain_class('profiles::kafka') }
  end
end
