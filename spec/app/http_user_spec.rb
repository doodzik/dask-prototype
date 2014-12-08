require 'support_http'

require 'http_user'

describe Api::User do
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return('')
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

=begin
  it 'get /users/:id' do
    Mongodb::User.should_receive(:current).and_return('The RSpec Book')
    Mongodb::User.any_instance.stub(:authenticated?).and_return(true)
    get '/users/1'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('The RSpec Book')
  end

  it 'post /users' do
    post '/users'
    expect(last_response).to be_successful
    expect(last_response.body).to eql('"user.save!"')
  end

  it 'put /users/:id' do
    put '/users/5'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"erroring"')
  end

  it 'delete /users/:id' do
    delete '/users/5'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('"Mongoid::User.find(params[:id]).delete"')
  end
=end
end
