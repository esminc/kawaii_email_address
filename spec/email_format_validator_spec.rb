require 'email_format_validator/address'

describe EmailFormatValidator::Address do

  RSpec::Matchers.define(:pass_validation_with) do |addr|
    match do |validator_klass|
      validator_klass.new(addr).valid?
    end
  end

  subject { EmailFormatValidator::Address }

  it { should pass_validation_with 'a@example.com' }
  it { should pass_validation_with 'a.!/==@example.com' }

  it { should_not pass_validation_with 'a@bc@example.com' }
  it { should_not pass_validation_with 'a..b@example.com' }
  it { should_not pass_validation_with 'a.@example.com' }
  it { should_not pass_validation_with '.aaa@example.com' }

  it { should pass_validation_with '"a@a"@example.com' }
  it { should pass_validation_with "'or'1'='1'--@example.com" }

  context 'kawaii: aka.docomo' do
    it { should pass_validation_with 'mail..example@docomo.ne.jp' }
    it { should pass_validation_with 'example.@docomo.ne.jp' }
    it { should pass_validation_with '.example@docomo.ne.jp' }
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
