# frozen_string_literal: true

require 'spec_helper'

describe 'profiles::puppet::g10k' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'puppet_repo_url' => 'https://bitbucket.org/landcareresearch/g10k-environment.git' } }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
