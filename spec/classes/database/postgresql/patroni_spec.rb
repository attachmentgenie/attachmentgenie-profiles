# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::database::postgresql::patroni' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) { 'include profiles::database::postgresql' }
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
