# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::bootstrap::systemd::resolved_conf' do
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'settings' => {}
        }
      end

      it { is_expected.to compile }
    end
  end
end
