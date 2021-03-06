require 'support_http'
require 'task_daily_api'

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
    described_class.new
  end

  it 'post /tasks/daily' do
    pending
    allow(task).to receive(:check).with(123)
    post '/tasks/daily', time: 123, id: 123
    expect(last_response.body).to eql('saved'.to_json)
  end

  it 'delete /tasks/daily/:id' do
    allow(task).to receive(:uncheck)
    delete '/tasks/daily/5'
    expect(last_response.body).to eql('saved'.to_json)
  end
end
