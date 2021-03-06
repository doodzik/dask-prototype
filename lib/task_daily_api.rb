require 'grape'
require 'helpers_api'

module Api
  # top comment
  class TaskDaily < Grape::API
    default_error_status 400
    format :json

    helpers Helpers

    before do
      @current_user = authenticate!(headers['Authentication'])
      error!('401 Unauthorized', 401) unless @current_user
    end

    params do
      requires :id
    end
    desc 'POST /tasks taskDaily#create '
    post '/tasks/daily' do
      task = @current_user.tasks.find params[:id]
      task.check(Time.now)
      task.save
    end

    params do
      requires :id
    end
    delete '/tasks/daily/:id' do
      task = @current_user.tasks.find params[:id]
      task.uncheck
      task.save
    end
  end
end
