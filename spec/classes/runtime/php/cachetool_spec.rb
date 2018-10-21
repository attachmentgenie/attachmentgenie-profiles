require 'spec_helper'
describe 'profiles::runtime::php::cachetool' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults for all parameters' do
        it { is_expected.to compile }
      end

      context 'install' do
        context 'with install_method set to package' do
          let(:params) do
            {
              install_method: 'package',
              package_name: 'cachetool',
            }
          end

          it { is_expected.to contain_package('cachetool') }
        end

        context 'with package_name set to specialpackage' do
          let(:params) do
            {
              install_method: 'package',
              package_name: 'specialpackage',
            }
          end

          it { is_expected.to contain_package('cachetool').with_name('specialpackage') }
        end

        context 'with package_version set to 42.42.42' do
          let(:params) do
            {
              install_method: 'package',
              package_name: 'cachetool',
              package_version: '42.42.42',
            }
          end

          it { is_expected.to contain_package('cachetool').with_ensure('42.42.42') }
        end
      end
    end
  end
end
