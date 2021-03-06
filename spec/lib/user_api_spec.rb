require 'support_http'
require 'user_api'

describe Api::User do
  let(:user) { double('user') }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return(user)
    end
  end
  include Rack::Test::Methods

  def app
    described_class.new
  end

  it 'get /users/:id' do
    pending
    get '/users/1'
    expect(last_response.body).to eq(user.to_json)
  end

  describe 'post /user' do
    it 'successful' do
      user_new = instance_double('User', save: true, email: 'correct')
      allow(Mongodb::User).to receive(:extended_new).and_return(user_new)
      post '/users', password: 'afsdfasg', email: 'hi@test.de'
      expect(last_response.body)
        .to eql({ email: user_new.email }.to_json)
    end

    it 'fails with wrong data' do
      user_new = instance_double('User', save: false)
      allow(Mongodb::User).to receive(:extended_new).and_return(user_new)
      post '/users', password: 'afsdfasg', email: 'hi@test.de'
      expect(last_response.body).to eql({ error: 'check your data' }.to_json)
    end
  end

  it 'put /users/:id' do
    pending
    user_new = instance_double('User', compare_password: true)
    allow(user_new).to receive(:email=).with('hi@test.de')
    allow(user_new).to receive(:save).and_return(user_new)
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticate!).and_return(user_new)
    end
    put '/users/5', password: 'asdffewaf', email: 'hi@test.de'
    expect(last_response.body).to eql(user_new.to_json)
  end
end
