require 'grape'
require 'helpers_api'
require 'trigger_mongoid'

module Api
  # top comment
  class Trigger < Grape::API
    default_error_status 400
    format :json

    helpers Helpers

    before do
      @current_user = authenticate!(headers['Authentication'])
      error!('401 Unauthorized', 401) unless @current_user
    end

    desc 'GET /triggers display a list of all trigger elements'
    get '/triggers' do
      @current_user.triggers
    end

    params do
      requires :id
    end
    desc 'GET /triggers/:id triggers#show display a specific trigger'
    get '/triggers/:id' do
      @current_user.triggers.find params[:id]
    end

    params do
      requires :name
    end
    desc 'POST /triggers triggers#create create a new trigger'
    post '/triggers' do
      trigger = Mongodb::Trigger.new(name: params[:name])
      @current_user.triggers << trigger
      trigger
    end

    params do
      requires :name
    end
    desc 'PATCH/PUT /triggers/:id triggers#update update a specific trigger'
    put '/triggers/:id' do
      trigger = @current_user.triggers.find params[:id]
      trigger.name         = params[:name]
      trigger.save
    end

    params do
      requires :id
    end
    delete '/triggers/:id' do
      @current_user.triggers.find(params[:id]).delete
    end
  end
end
