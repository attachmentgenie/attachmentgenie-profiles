# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::database::mysql::user' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'dbname' => 'test',
      'grants' => ['ALL'],
      'password' => 'secret'
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
