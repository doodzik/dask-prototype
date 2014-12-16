require 'support_http'

require 'http_auth'

describe Auth::Api do
  include Rack::Test::Methods

  def app
    Auth::Api
  end

  it 'post /token returns error' do
    user = instance_double('User', save: false)
    allow(Mongodb::User).to receive(:login)
      .with('a@bc.de', '1234567').and_return(user)
    post '/token', password: '1234567', email: 'a@bc.de'
    expect(last_response.body).to eql('password or email was false')
  end

  it 'post /token returns token with' do
    user = instance_double('User', save: true, to_bearer: 'works')
    allow(Mongodb::User).to receive(:login)
      .with('a@bc.de', '1234567').and_return(user)
    post '/token', password: '1234567', email: 'a@bc.de'
    expect(last_response.body).to eql('works')
  end
end
