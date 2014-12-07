=begin
require 'support'

require 'rspec'
require 'rack/test'


require 'contracts/http.rb'
require 'adapters/http_auth.rb'

describe Http::Auth do
  include Rack::Test::Methods

  def app
    Http::Server.new
  end
=begin
  it 'get /auths' do
    get '/auths'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"Mongoid::Auth.all"')
  end

  it 'get /auths/:id' do
    get '/auths/:id'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('"Mongoid::Auth.find(params[:id])"')
  end

  it 'post /auths' do
    post '/auths'
    expect(last_response).to be_successful
    expect(last_response.body).to eql('"auth.save!"')
  end

  it 'put /auths/:id' do
    put '/auths/5'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"erroring"')
  end

  it 'delete /auths/:id' do
    delete '/auths/5'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('"Mongoid::Auth.find(params[:id]).delete"')
  end
#=end
#end
=end
