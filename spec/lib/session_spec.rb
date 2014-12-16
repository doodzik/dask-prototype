require 'support'
require 'session'

describe Session do
  it '.secure_compare' do
    allow(Session).to receive(:blank?)
      .with('a', 'b').and_return(true)
    allow(Session).to receive(:compare_bytes)
      .with('a', 'b').and_return(true)
    expect(Session.secure_compare('a', 'b')).to eq(false)
    allow(Session).to receive(:blank?)
      .with('a', 'b').and_return(false)
    expect(Session.secure_compare('a', 'b')).to eq(true)
    allow(Session).to receive(:compare_bytes)
      .with('a', 'b').and_return(false)
    expect(Session.secure_compare('a', 'b')).to eq(false)
  end

  it '.generate_unique_token' do
    allow(Session).to receive(:generate_token).and_return(0, 1)
    new_token = Session.generate_unique_token do |token|
      token != 1
    end
    expect(new_token).to eq(1)
  end

  it '.generate_token' do
    allow(SecureRandom).to receive(:urlsafe_base64).with(nil, false)
    Session.send :generate_token
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
