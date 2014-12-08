require 'http_user'
require 'http_auth'

module Api
  # comment
  class Main < Grape::API
    format :json

    mount Api::Auth

    namespace 'api' do
      mount Api::User
    end
  end
end
