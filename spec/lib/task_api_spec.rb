require 'support_http'
require 'task_api'

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
    described_class.new
  end

  it 'get /tasks' do
    get '/tasks'
    expect(last_response.body).to eql(tasks.to_json)
  end

  it 'get /tasks/:id' do
    get '/tasks/5'
    expect(last_response.body).to eql(task.to_json)
  end

  it 'post /tasks' do
    allow(Mongodb::Task).to receive(:new).with(days: [1, 4], name: 'test')
      .and_return(task)
    allow(tasks).to receive(:<<).with(task)
    post '/tasks', days: [1, 4], name: 'test'
    expect(last_response.body).to eql(task.to_json)
  end

  it 'put /tasks/:id' do
    allow(task).to receive(:days=).with([1])
    allow(task).to receive(:name=).with('te')
    put '/tasks/5', days: [1], name: 'te'
    expect(last_response.body).to eql('saved'.to_json)
  end

  it 'delete /tasks/:id' do
    delete '/tasks/5'
    expect(last_response.body).to eql('deleted'.to_json)
  end
end
