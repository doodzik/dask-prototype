require 'grape'
require 'http_helpers'

# top comment
module Http
  # top comment
  class Task < Grape::API
    default_error_status 400
    format :json

    #helpers HttpHelpers

    #before { authenticate! }

    desc 'GET	/tasks	display a list of all task elements'
    get '/tasks' do
      '@current_user.tasks.for_this_day.map(&to_h)'
    end
=begin
    desc 'GET	/tasks/:id	tasks#show	display a specific task'
    params do
      requires :id
    end
    get '/tasks/:id' do
      @current_user.tasks.find params[:id]
    end

    desc 'POST	/tasks	tasks#create	create a new task'
    post '/tasks' do
      Mongodb::Task.new(
        days: params[:days],
        name: params[:name],
        user: @current_user
      ).save
    end

    desc 'PATCH/PUT	/tasks/:id	tasks#update	update a specific task'
    put '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      if task.checked? == params[:checked]
        task.days = params[:days]
      else
        task.check
      end.save
    end

    delete '/tasks/:id' do
      @current_user.tasks.find(params[:id]).delete
    end
  end
=end
end
