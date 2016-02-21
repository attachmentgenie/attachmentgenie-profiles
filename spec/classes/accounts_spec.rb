require 'spec_helper'
describe 'profiles::accounts' do

  context 'with defaults for all parameters' do
    let(:facts) { {:osfamily => 'debian'} }
    it { should contain_class('profiles::accounts') }
  end
end
