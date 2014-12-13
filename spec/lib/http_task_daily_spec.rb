require 'support_http'
require 'http_task_daily'

describe Api::TaskDaily do
  include Rack::Test::Methods

  let(:task) { double('task', save: 'saved') }
  let(:tasks) { double('tasks', find: task) }
  let(:user) { double('user', tasks: tasks) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive_message_chain(:authenticate!).and_return(user)
    end
  end
  def app
    Api::TaskDaily.new
  end

  it 'post /tasks' do
    allow(task).to receive(:check).with(123)
    post '/tasks', time: 123, id: 123
    expect(last_response.body).to eql('saved'.to_json)
  end

  it 'delete /tasks/:id' do
    allow(task).to receive(:uncheck)
    delete '/tasks/5'
    expect(last_response.body).to eql('saved'.to_json)
  end
end
