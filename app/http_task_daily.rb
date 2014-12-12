require 'grape'
require 'http_helpers'

# top comment
module Api
  # top comment
  class TaskDaily < Grape::API
    default_error_status 400
    format :json

    helpers HttpHelpers

    before do
      @current_user = authenticate!(headers[:authentication])
      error!('401 Unauthorized', 401) unless @current_user
    end

    params do
      requires :time, type: Integer
    end
    desc 'POST	/tasks	tasks#create	create a new task'
    post '/tasks' do
      task = @current_user.tasks.find params[:id]
      task.check(params[:time])
      task.save
    end

    delete '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      task.uncheck
      task.save
    end
  end
end
