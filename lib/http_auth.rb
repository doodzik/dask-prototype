require 'grape'
require 'mongoid_user'
require 'http_helpers'

module Api
  # Through this class a user can get authenticated
  class Auth < Grape::API
    params do
      requires :email, regexp: /.+@.+/
      requires :password, within: 6..32
    end
    desc 'autheticate a user with email and password'
    post '/token' do
      user = Mongodb::User.login(params[:email], params[:password])
      user.save ? user.to_bearer : error!('password or email was false')
    end
  end
end
