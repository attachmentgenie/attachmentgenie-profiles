require 'spec_helper'
describe 'profiles::database::postgresql' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(root_home: '/root')
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::database::postgresql') }
        it { is_expected.to contain_firewall('200 allow pgsql').with_action('accept').with_dport(5432) }
        it { is_expected.to contain_profiles__bootstrap__firewall__entry('200 allow pgsql').with_action('accept').with_port(5432) }
      end
    end
  end
end
