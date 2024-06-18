require 'spec_helper'
describe 'profiles::bootstrap::firewall::entry' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with foo set to bar' do
        let(:title) { 'foo' }

        it { is_expected.to contain_firewall('foo').with_jump('accept') }
      end
    end
  end
end
