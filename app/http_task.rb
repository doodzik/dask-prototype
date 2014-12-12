require 'grape'
require 'http_helpers'
require 'mongoid_task'

# top comment
module Api
  # top comment
  class Task < Grape::API
    default_error_status 400
    format :json

    helpers HttpHelpers

    before do
      @current_user = authenticate!(headers[:authentication])
      error!('401 Unauthorized', 401) unless @current_user
    end

    desc 'GET	/tasks	display a list of all task elements'
    # TODO: rewrite client to handle the querying
    get '/tasks' do
      @current_user.tasks
    end

    desc 'GET	/tasks/:id	tasks#show	display a specific task'
    get '/tasks/:id' do
      @current_user.tasks.find params[:id]
    end

    desc 'POST	/tasks	tasks#create	create a new task'
    post '/tasks' do
      task = Mongodb::Task.new(
        days: params[:days],
        name: params[:name],
        user: @current_user
      )
      task.save
    end

    desc 'PATCH/PUT	/tasks/:id	tasks#update	update a specific task'
    # TODO: check(now in task daily) should be an own endpoint on client
    put '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      task.days = params[:days]
      task.save
    end

    delete '/tasks/:id' do
      @current_user.tasks.find(params[:id]).delete
    end
  end
end
