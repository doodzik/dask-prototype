require 'user_api'
require 'auth_api'
require 'task_api'
require 'task_daily_api'

module Main
  # main api is invoked by config.ru
  class Api < Grape::API
    format :json

    mount Auth::Api

    namespace 'api' do
      mount Api::User
      mount Api::Task
      mount Api::TaskDaily
    end
  end
end
