# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::scheduling::nomad::host_volume' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'data_path' => '/opt/nomad'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
