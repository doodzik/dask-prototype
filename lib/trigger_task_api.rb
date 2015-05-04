require 'grape'
require 'helpers_api'
require 'trigger_mongoid'

module Api
  # top comment
  class TriggerTask < Grape::API
    default_error_status 400
    format :json

    helpers Helpers

    before do
      @current_user = authenticate!(headers['Authentication'])
      error!('401 Unauthorized', 401) unless @current_user
    end

    params do
      requires :name
    end
    desc 'POST /trigger/tasks triggers#create create a new trigger'
    post '/trigger/:id/tasks' do
      trigger = @current_user.triggers.find params[:id]
      trigger.tasks << params[:name]
      trigger.tasks.uniq
      trigger.save
    end

    desc 'POST /trigger/tasks triggers#create create a new trigger'
    post '/trigger/:id/trigger' do
      trigger = @current_user.triggers.find params[:id]
      t_name = trigger.name
      trigger.tasks.map do |t|
        @current_user.tasks << Mongodb::Task.new(name: "#{t_name}: #{t}", onetime: true)
      end
    end

    params do
      requires :name
      requires :new_name
    end
    desc 'PATCH/PUT /trigger/tasks/:id triggers#update update a specific trigger'
    put '/trigger/tasks/:id' do
      trigger = @current_user.triggers.find params[:id]
      i = trigger.tasks.index(params[:name])
      trigger.tasks[i] = params[:new_name]
      trigger.save
    end

    params do
      requires :id
    end
    delete '/trigger/:id/tasks' do
      trigger = @current_user.triggers.find(params[:id])
      trigger.tasks.delete(params[:name])
      @current_user.save
    end
  end
end
