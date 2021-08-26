# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  class { '::profiles':
    install_method => 'archive',
    archive_source => 'https://github.com/profiles/profiles/releases/download/v1.0.1/profiles_linux_amd64',
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe file('/usr/bin/profiles') do
    it { is_expected.to be_file }
    it { is_expected.to be_executable }
  end

  if os[:family] == 'redhat'
    describe file('/etc/sysconfig/profiles') do
      it { is_expected.to be_file }
    end
  elsif ['debian', 'ubuntu'].include?(os[:family])
    describe file('/etc/default/profiles') do
      it { is_expected.to be_file }
    end
  end

  describe service('profiles') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(1025) do
    it { is_expected.to be_listening }
  end
end
