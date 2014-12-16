require 'http_user'
require 'http_auth'
require 'http_task'
require 'http_task_daily'

module Main
  # main api
  class Api < Grape::API
    format :json

    mount Auth::Auth

    namespace 'api' do
      mount Api::User
      mount Api::Task
      mount Api::TaskDaily
    end
  end
end
