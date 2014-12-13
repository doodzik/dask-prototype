require 'grape'
require 'mongoid_user'

module Api
  # comment
  class Auth < Grape::API
    post '/token' do
      user = Mongodb::User.login(params[:email], params[:password])
      user.save ? user.to_bearer : error!('password or email was false')
    end
  end
end
