require 'support'
require 'auth'

describe Auth do
  it '.generate_unique_token' do
    allow(described_class).to receive(:generate_token).and_return(0, 1)
    new_token = described_class.generate_unique_token do |token|
      token != 1
    end
    expect(new_token).to eq(1)
  end

  it '.generate_unique_user_token' do
    allow(described_class).to receive(:generate_unique_token)
      .and_yield('value').and_return('valueX')
    allow(Mongodb::User).to receive(:find_by).with(token: 'value')
    expect(described_class.generate_unique_user_token).to eql('valueX')
  end

  it '.generate_token' do
    allow(SecureRandom).to receive(:urlsafe_base64).with(nil, false)
    described_class.send :generate_token
  end
end
