require 'spec_helper'

describe 'profiles::foreman', :type => :class do
  it { is_expected.to compile }
  it { should contain_class('profiles::foreman') }
end