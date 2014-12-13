require 'support_http'
require 'http_task'

describe Api::Task do
  include Rack::Test::Methods

  let(:task) { double('task', save: 'saved', delete: 'deleted') }
  let(:tasks) { double('tasks', find: task) }
  let(:user) { double('user', tasks: tasks) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return(user)
    end
  end

  def app
    Api::Task.new
  end

  it 'get /tasks' do
    get '/tasks'
    expect(last_response.body).to eql(tasks.to_json)
  end

  it 'get /tasks/:id' do
    get '/tasks/:id'
    expect(last_response.body).to eql(task.to_json)
  end

  it 'post /tasks' do
    allow(Mongodb::Task).to receive(:new).and_return(task)
    allow(tasks).to receive(:<<).with(task)
    post '/tasks'
    expect(last_response.body).to eql(task.to_json)
  end

  it 'put /tasks/:id' do
    allow(task).to receive(:days=).with(['sunday'])
    put '/tasks/5', days: [:sunday]
    expect(last_response.body).to eql('saved'.to_json)
  end

  it 'delete /tasks/:id' do
    delete '/tasks/5'
    expect(last_response.body).to eql('deleted'.to_json)
  end
end
