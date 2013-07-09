require 'email_format_validator/address'

describe EmailFormatValidator::Address do

  subject(:address) { EmailFormatValidator::Address.new(addr) }

  context 'when a@example.com' do
    let(:addr) { 'a@example.com' }
    it { should be_valid }
  end

  context 'when a@example.com' do
    let(:addr) { 'a.!/==@example.com' }
    it { should be_valid }
  end

  context 'when a@example.com' do
    let(:addr) { 'a@bc@example.com' }
    it { should_not be_valid }
  end

  context 'when a..@example.com' do
    let(:addr) { 'a..b@example.com' }
    it { should_not be_valid }
  end

  context 'when a.@example.com' do
    let(:addr) { 'a.@example.com' }
    it { should_not be_valid }
  end

  context 'when .aaa@example.com' do
    let(:addr) { '.aaa@example.com' }
    it { should_not be_valid }
  end

  context 'not valid case' do
    let(:addr) { 'a@a@a' }
    it { should_not be_valid }
  end

  context 'quotes @' do
    let(:addr) { '"a@a"@example.com' }
    it { should be_valid }
  end

  context 'complex symbols' do
    let(:addr) { "'or'1'='1'--@example.com" }
    it { should be_valid }
  end

  context 'has double dots' do
    let(:addr) { 'mail..example@docomo.ne.jp' }
    it { should be_valid }
  end

  context 'dot just before @' do
    let(:addr) { 'example.@docomo.ne.jp' }
    it { should be_valid }
  end

  context 'start with dot' do
    let(:addr) { '.example@docomo.ne.jp' }
    it { should be_valid }
  end

  context 'domain part too short' do
    let(:addr) { 'example@c' }
    it { should_not be_valid }
  end

  context 'domain part start with hyphen' do
    let(:addr) { 'example@-com.jp' }
    it { should_not be_valid }
  end

  context 'domain part end with hyphen' do
    let(:addr) { 'example@com.jp-' }
    it { should_not be_valid }
  end

  context 'domain last part too short' do
    let(:addr) { 'example@com.j' }
    it { should_not be_valid }
  end

  context 'domain part is valid domain literal' do
    let(:addr) { 'example@[115.146.17.185]' }
    it { should be_valid }
  end

  context 'domain part is invalid domain literal' do
    let(:addr) { 'example@[115.146.1722]' }
    it { should_not be_valid }
  end
end
