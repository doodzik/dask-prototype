require 'support_http'

require 'auth_api'

describe Auth::Api do
  include Rack::Test::Methods

  def app
    Auth::Api
  end

  describe 'post /token' do
    it 'fails' do
      user = instance_double('User', save: false)
      allow(Mongodb::User).to receive(:login)
        .with('a@bc.de', '1234567').and_return(user)
      post '/auth', password: '1234567', email: 'a@bc.de'
      expect(last_response.body).to eql('password or email was false')
    end

    it 'succeeds returns token' do
      user = instance_double('User', save: true, to_bearer: 'works')
      allow(Mongodb::User).to receive(:login)
        .with('a@bc.de', '1234567').and_return(user)
      post '/auth', password: '1234567', email: 'a@bc.de'
      expect(last_response.body).to eql('works')
    end
  end
end
