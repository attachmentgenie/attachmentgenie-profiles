require 'spec_helper'
describe 'profiles::neo4j' do

  context 'with defaults for all parameters' do
    it { should contain_class('profiles::neo4j') }
  end
end
