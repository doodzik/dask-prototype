require 'support'
require 'auth'

describe Auth do
  it '.secure_compare' do
    allow(Auth).to receive(:blank?)
      .with('a', 'b').and_return(true)
    allow(Auth).to receive(:compare_bytes)
      .with('a', 'b').and_return(true)
    expect(Auth.secure_compare('a', 'b')).to eq(false)
    allow(Auth).to receive(:blank?)
      .with('a', 'b').and_return(false)
    expect(Auth.secure_compare('a', 'b')).to eq(true)
    allow(Auth).to receive(:compare_bytes)
      .with('a', 'b').and_return(false)
    expect(Auth.secure_compare('a', 'b')).to eq(false)
  end

  it '.generate_unique_token' do
    allow(Auth).to receive(:generate_token).and_return(0, 1)
    new_token = Auth.generate_unique_token do |token|
      token != 1
    end
    expect(new_token).to eq(1)
  end

  it '.generate_token' do
    allow(SecureRandom).to receive(:urlsafe_base64).with(nil, false)
    Auth.send :generate_token
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
