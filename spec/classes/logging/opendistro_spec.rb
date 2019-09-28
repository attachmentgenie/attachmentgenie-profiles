require 'spec_helper'
describe 'profiles::logging::opendistro' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
      end
    end
  end
end
