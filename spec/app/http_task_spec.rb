=begin
ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'


require './contracts/http.rb'
require './adapters/http_task.rb'

describe Http::Task do
  include Rack::Test::Methods

  def app
    Http::Server.new
  end

=begin
  it 'get /tasks' do
    get '/tasks'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"Mongoid::Task.all"')
  end

  it 'get /tasks/:id' do
    get '/tasks/:id'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('"Mongoid::Task.find(params[:id])"')
  end

  it 'post /tasks' do
    post '/tasks'
    expect(last_response).to be_successful
    expect(last_response.body).to eql('"task.save!"')
  end

  it 'put /tasks/:id' do
    put '/tasks/5'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('"erroring"')
  end

  it 'delete /tasks/:id' do
    delete '/tasks/5'
    expect(last_response).to be_ok
    expect(last_response.body)
    .to eql('"Mongoid::Task.find(params[:id]).delete"')
  end
end

=end
