require 'support_http'

require 'http_user'

describe Api::User do
  let(:user) { double('user') }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return(user)
    end
  end
  include Rack::Test::Methods

  def app
    Api::User
  end

  # it 'get' do
  #   get '/'
  #   expect(last_response.body).to eql('hi')
  # end

  it 'get /users/:id' do
    get '/users/1'
    expect(last_response.body).to eq(user.to_json)
  end

  it 'post /user successful' do
    user_new = double('user', save: true, email: 'correct')
    allow(Mongodb::User).to receive(:extendet_new).and_return(user_new)
    post '/users'
    expect(last_response.body).to eql({ password: '', email: user_new.email }.to_json)
  end

  it 'post /user unsuccessful' do
    user_new = double('user', save: false)
    allow(Mongodb::User).to receive(:extendet_new).and_return(user_new)
    post '/users'
    expect(last_response.body).to eql({error:'check your data'}.to_json)
  end


  it 'put /users/:id' do
    pending 'how to check if save is being called and email is assigned'
    user_new = double('user', compare_password: true)
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticate!).and_return(user_new)
    end
    put '/users/5'
    expect(user_new).to have_received(:email)
    expect(user_new).to have_received(:save)
    expect(last_response.body).to eql(user_new.to_json)
  end

  # it 'delete /users/:id' do
  #   delete '/users/5'
  #   expect(last_response).to be_ok
  #   expect(last_response.body)
  #   .to eql('"Mongoid::User.find(params[:id]).delete"')
  # end
end
