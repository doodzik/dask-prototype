require 'support'
require 'helpers_api'

describe Api::Helpers do
  context '.authenticate!' do
    let(:helper) { Object.new.extend(described_class) }
    let(:user) { instance_double('User') }
    let(:auth) { allow(user).to receive(:authenticated?).with('token') }
    before do
      allow(Mongodb::User).to receive(:current)
        .with('token').and_return(user)
    end

    it 'succeeds' do
      auth.and_return(true)
      expect(helper.authenticate!('token')).to eq(user)
    end

    it 'fails' do
      auth.and_return(false)
      expect(helper.authenticate!('token')).to eq(false)
    end
  end
end
