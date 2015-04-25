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
      @current_user = authenticate!(headers['Authentication'])
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
      requires :name
      optional :days, type: Array[Integer], default: []


      requires :startHour,    type: Integer, default: 0, values: 0..23
      requires :startMinute,  type: Integer, default: 0, values: 0..59
      requires :endHour,      type: Integer, default: 23, values: 0..23
      requires :endMinute,    type: Integer, default: 59, values: 0..59
      requires :intervalType, type: Integer, default: 0, values: 0..2
      requires :interval,     type: Integer, default: 1, values: 1..99
      requires :startDate,    type: String, default: -> {  Time.now.strftime("%Y-%m-%d") } # , length: 140
    end
    desc 'POST /tasks tasks#create create a new task'
    post '/tasks' do
      task = Mongodb::Task.new(
        days:         params[:days].select { |day| (0..6).include?(day) },
        name:         params[:name],
        startHour:    params[:startHour],
        startMinute:  params[:startMinute],
        endHour:      params[:endHour],
        endMinute:    params[:endMinute],
        intervalType: params[:intervalType],
        interval:     params[:interval],
        startDate:    params[:startDate]
      )
      @current_user.tasks << task
      task
    end

    params do
      requires :name
      optional :days, type: Array[Integer], default: []

      requires :startHour,    type: Integer, default: 0, values: 0..23
      requires :startMinute,  type: Integer, default: 0, values: 0..59
      requires :endHour,      type: Integer, default: 23, values: 0..23
      requires :endMinute,    type: Integer, default: 59, values: 0..59
      requires :intervalType, type: Integer, default: 0, values: 0..2
      requires :interval,     type: Integer, default: 1, values: 1..99
      requires :startDate,    type: String, default: -> {  Time.now.strftime("%Y-%m-%d") }
    end
    desc 'PATCH/PUT /tasks/:id tasks#update update a specific task'
    put '/tasks/:id' do
      task = @current_user.tasks.find params[:id]
      task.name         = params[:name]
      task.days         = params[:days].select { |day| (0..6).include?(day) }
      task.startHour    = params[:startHour]
      task.startMinute  = params[:startMinute]
      task.endHour      = params[:endHour]
      task.endMinute    = params[:endMinute]
      task.intervalType = params[:intervalType]
      task.interval     = params[:interval]
      task.startDate    = params[:startDate]
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
