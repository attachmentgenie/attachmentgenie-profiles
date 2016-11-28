require 'spec_helper'

describe 'profiles::foreman_proxy', :type => :class do
  it { is_expected.to compile }
  it { should contain_class('profiles::foreman_proxy') }
end