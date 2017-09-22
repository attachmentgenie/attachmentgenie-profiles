require 'spec_helper'
describe 'profiles::mq' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::mq') }
  end
end
