require 'support'
require 'auth'

describe Auth do
  it '.secure_compare' do
    allow(described_class).to receive(:blank?)
      .with('a', 'b').and_return(true)
    allow(described_class).to receive(:compare_bytes)
      .with('a', 'b').and_return(true)
    expect(described_class.secure_compare('a', 'b')).to eq(false)
    allow(described_class).to receive(:blank?)
      .with('a', 'b').and_return(false)
    expect(described_class.secure_compare('a', 'b')).to eq(true)
    allow(described_class).to receive(:compare_bytes)
      .with('a', 'b').and_return(false)
    expect(described_class.secure_compare('a', 'b')).to eq(false)
  end

  it '.generate_unique_token' do
    allow(described_class).to receive(:generate_token).and_return(0, 1)
    new_token = described_class.generate_unique_token do |token|
      token != 1
    end
    expect(new_token).to eq(1)
  end

  it '.generate_token' do
    allow(SecureRandom).to receive(:urlsafe_base64).with(nil, false)
    described_class.send :generate_token
  end

  it '.blank?' do
    skip
  end

  it '.blank_string?' do
    skip
  end

  it '.compare_bytes' do
    skip
  end
end
