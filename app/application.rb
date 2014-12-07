require 'http_user'

module Api
  class Main < Grape::API
    format :json

    mount Api::User
  end
end
