require 'spec_helper'
describe 'profiles::tools' do
  context 'with defaults for all parameters' do
    it { is_expected.to contain_class('profiles::tools') }
  end
end
