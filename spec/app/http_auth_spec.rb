require 'support_http'

require 'http_auth'

describe Api::Auth do
  include Rack::Test::Methods

  def app
    Api::Auth
  end

  it 'post /token returns error' do
    user = double('user', save: false)
    allow(Mongodb::User).to receive_message_chain(:login).and_return(user)
    post '/token'
    expect(last_response.body).to eql('password or email was false')
  end

  it 'post /token returns token with' do
    user = double('user', save: true, to_bearer: 'works')
    allow(Mongodb::User).to receive_message_chain(:login).and_return(user)
    post '/token'
    expect(last_response.body).to eql('works')
  end
end
