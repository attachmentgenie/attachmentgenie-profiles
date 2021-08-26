# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::metrics::grafana::plugin' do
  let(:pre_condition) { 'include grafana' }
  let(:title) { 'namevar' }
  let(:params) do
    {}
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
