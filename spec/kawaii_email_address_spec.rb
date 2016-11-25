require 'spec_helper'
require 'kawaii_email_address/validator'

describe KawaiiEmailAddress::Validator do

  RSpec::Matchers.define(:pass_validation_with) do |addr|
    match do |validator_klass|
      validator_klass.new(addr).valid?
    end
  end

  subject { KawaiiEmailAddress::Validator }

  it { should pass_validation_with 'a@example.com' }
  it { should pass_validation_with 'a.!/==@example.com' }

  it { should_not pass_validation_with 'a@bc@example.com' }
  it { should_not pass_validation_with 'a..b@example.com' }
  it { should_not pass_validation_with 'a.@example.com' }
  it { should_not pass_validation_with '.aaa@example.com' }

  it { should pass_validation_with '"a@a"@example.com' }
  it { should_not pass_validation_with 'a"b"@example.com' }
  it { should_not pass_validation_with '"a"b@example.com' }
  it { should_not pass_validation_with '"a"b"@example.com' }
  it { should pass_validation_with "'or'1'='1'--@example.com" }

  it { should_not pass_validation_with 'example_address' }

  it { should_not pass_validation_with '@example.com' }

  context 'kawaii: aka.docomo' do
    it { should pass_validation_with 'mail..example@docomo.ne.jp' }
    it { should pass_validation_with 'example.@docomo.ne.jp' }
    it { should pass_validation_with '.example@docomo.ne.jp' }

    it { should pass_validation_with 'u3u..chu.@docomo.ne.jp' }
    it { should pass_validation_with '....-_-....@docomo.ne.jp' }
  end

  context 'domain part' do
    it { should_not pass_validation_with 'example@c' }
    it { should_not pass_validation_with 'example@-com.jp' }
    it { should_not pass_validation_with 'example@com.jp-' }
    it { should_not pass_validation_with 'example@com.j' }

    it { should     pass_validation_with 'example@[115.146.17.185]' }
    it { should_not pass_validation_with 'example@[115.146.1722]' }
  end
end
