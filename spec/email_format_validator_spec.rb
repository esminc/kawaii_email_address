require 'email_format_validator'

describe EmailFormatValidator::Address do

  subject(:address) { EmailFormatValidator::Address.new(addr) }

  context 'when a@foo.com' do
    let(:addr) { 'a@foo.com' }
    it { should be_valid }
  end

  context 'when a..@foo.com' do
    let(:addr) { 'a..@foo.com' }
    it { should_not be_valid }
  end
end
