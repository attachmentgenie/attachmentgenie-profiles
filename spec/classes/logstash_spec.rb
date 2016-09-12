require 'spec_helper'
describe 'profiles::logstash' do
  context 'with defaults for all parameters' do
    it { should contain_class('profiles::logstash') }
  end
end
