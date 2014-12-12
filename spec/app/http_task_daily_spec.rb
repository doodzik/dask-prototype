require 'support_http'
require 'http_task'

describe Api::Task do
  include Rack::Test::Methods

  let(:user) { double('user') }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return(user)
    end
  end
  def app
    Api::Task.new
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
=end
end

