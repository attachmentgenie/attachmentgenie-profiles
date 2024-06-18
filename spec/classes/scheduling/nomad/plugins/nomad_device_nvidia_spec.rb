# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::scheduling::nomad::plugins::nomad_device_nvidia' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
