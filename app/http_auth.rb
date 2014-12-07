require 'grape'
require 'mongoid_user'

# top comment
module Http
  # top comment
  class Auth < Grape::API
    default_error_status 400
    format :json

    desc 'generate token'
    get '/token' do
      user = Mongodb::User.find(params[:email])
      if user.compare_password(params[:password])
        user.token = Session.generate_unique_token do
          Mongo::User.find_by token: params[:token]
        end
        user.save ? user.to_bearer : error!('error')
      end
    end
  end
end
