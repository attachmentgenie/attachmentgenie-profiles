require 'spec_helper'

describe 'profiles::flink', :type => :class do
  it { is_expected.to compile }
  it { should contain_class('profiles::flink') }
end