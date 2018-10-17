require 'spec_helper'
describe 'profiles::monitoring::collectd' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge(collectd_version: '5.5.0',
                    python_dir: '/usr/local/lib/python2.7/dist-packages')
      end

      context 'with defaults for all parameters' do
        it { is_expected.to contain_class('profiles::monitoring::collectd') }
      end
    end
  end
end
