require 'rspec'
require 'string'

describe String do
  describe '.strict_eql?' do
    let(:str) { 'string' }
    let(:second_str) { 'string' }
    let(:present) { allow(str).to receive(:present?) }
    let(:present_second) { allow(second_str).to receive(:present?) }
    let(:eql_by_bytes) do
      allow(str).to receive(:equal_by_bytes?).with(second_str)
    end

    it 'has all true -> succeeds' do
      present.and_return(true)
      present_second.and_return(true)
      eql_by_bytes.and_return(true)
      expect(str.strict_eql?(second_str)).to be true
    end

    it 'has first false -> fails' do
      present.and_return(false)
      present_second.and_return(true)
      eql_by_bytes.and_return(true)
      expect(str.strict_eql?(second_str)).to be false
    end

    it 'has second false -> fails' do
      present.and_return(true)
      present_second.and_return(false)
      eql_by_bytes.and_return(true)
      expect(str.strict_eql?(second_str)).to be false
    end

    it 'has third true false -> fails' do
      present.and_return(true)
      present_second.and_return(true)
      eql_by_bytes.and_return(false)
      expect(str.strict_eql?(second_str)).to be false
    end
  end

  it '.blank?' do
    expect(''.blank?).to be true
    expect('not blank'.blank?).to be false
  end

  it '.present?' do
    expect(''.present?).to be false
    expect('not blank'.present?).to be true
  end

  it '.equal_bytesize?' do
    expect('string'.equal_bytesize? 'string').to be true
    expect('string3'.equal_bytesize? 'stringä').to be false
  end

  describe '.equal_by_bytes?' do
    it '#equal_bytesize? returns false' do
      str = 'hi'
      allow(str).to receive(:equal_bytesize?).and_return false
      expect(str.equal_by_bytes?('hi')).to be false
    end

    it '#equal_bytesize? returns true' do
      str = 'hi'
      allow(str).to receive(:equal_bytesize?).and_return true
      expect(str.equal_by_bytes?('hi')).to be true
    end
  end
end
