require 'grape'
require 'http_helpers'

# top comment
module Http
  # top comment
  class TaskDaily < Grape::API
    default_error_status 400
    format :json

    helpers HttpHelpers

    before { authenticate! }

    desc 'POST	/tasks	tasks#create	create a new task'
    post '/tasks' do
      task = @current_user.tasks.find params[:id]
      task.check(params[:time])
      task.save
    end

    delete '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      task.uncheck(params[:time])
      task.save
    end
  end
end
