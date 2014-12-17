require 'support_http'
require 'helpers_api'

describe Api::Helpers do
  context '.authenticate!' do
    before do
      @object = Object.new
      @object.extend(Api::Helpers)
      @user = instance_double('User')
      allow(Mongodb::User).to receive(:current)
        .with('token').and_return(@user)
      @auth = allow(@user).to receive(:authenticated?).with('token')
    end

    it 'succeeds' do
      @auth.and_return(true)
      expect(@object.authenticate!('token')).to eq(@user)
    end

    it 'fails' do
      @auth.and_return(false)
      expect(@object.authenticate!('token')).to eq(false)
    end
  end

  it 'validator within' do
    skip 'I have currently no idea how to test this'
  end
end
