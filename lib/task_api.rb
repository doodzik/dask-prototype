require 'grape'
require 'helpers_api'
require 'task_mongoid'

module Api
  # top comment
  class Task < Grape::API
    default_error_status 400
    format :json

    helpers Helpers

    before do
      @current_user = authenticate!(headers[:authentication])
      error!('401 Unauthorized', 401) unless @current_user
    end

    desc 'GET /tasks display a list of all task elements'
    get '/tasks' do
      # TODO: 'join' with timestamp from TaskDaily
      @current_user.tasks
    end

    params do
      requires :id
    end
    desc 'GET /tasks/:id tasks#show display a specific task'
    get '/tasks/:id' do
      @current_user.tasks.find params[:id]
    end

    params do
      optional :days, type: Array[Integer], default: []
      requires :name
    end
    desc 'POST /tasks tasks#create create a new task'
    post '/tasks' do
      task = Mongodb::Task.new(
        days: params[:days],
        name: params[:name]
      )
      @current_user.tasks << task
      task
    end

    params do
      optional :days, type: Array[Integer], default: []
      requires :name
    end
    desc 'PATCH/PUT /tasks/:id tasks#update update a specific task'
    put '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      task.name = params[:name]
      task.days = params[:days]
      task.save
    end

    params do
      requires :id
    end
    delete '/tasks/:id' do
      @current_user.tasks.find(params[:id]).delete
    end
  end
end
