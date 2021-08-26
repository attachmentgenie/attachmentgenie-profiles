# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::database::postgresql::db' do
  let(:pre_condition) { 'include profiles::database::postgresql' }
  let(:title) { 'namevar' }
  let(:params) do
    {
      'password' => 'secret',
      'user'     => 'root'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
