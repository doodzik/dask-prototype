require 'user_api'
require 'auth_api'
require 'task_api'
require 'task_daily_api'

module Main
  # main api is invoked by config.ru
  class API < Grape::API
    format :json

    namespace 'api' do
      mount Auth::Api
      mount Api::User
      mount Api::Task
      mount Api::TaskDaily
    end
  end
end
