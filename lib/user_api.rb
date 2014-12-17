require 'grape'
require 'helpers_api'
require 'user_mongoid'

# top comment
module Api
  # top comment
  class User < Grape::API
    default_error_status 400
    format :json
    helpers Helpers

    before do
      @current_user = authenticate!(headers[:authentication])
      error!('401 Unauthorized', 401) unless @current_user
    end

    desc 'GET	/users/:id	users#show	display a specific user'
    params do
      requires :id
    end
    get '/users/:id' do
      @current_user
    end

    params do
      requires :email, regexp: /.+@.+/
      requires :password, within: 6..32
    end
    desc 'POST	/users	users#create	create a new user'
    post '/users' do
      # TODO: refactor extendet_new into initializer
      user = Mongodb::User.extendet_new(
        email: params[:email],
        pw: params[:password]
      )
      user.save ? { email: user.email } : error!('check your data')
    end

    params do
      requires :email, regexp: /.+@.+/
      requires :password, within: 6..32
    end
    desc 'PATCH/PUT	/users/:id	users#update	update a specific user'
    put '/users/:id' do
      if @current_user.compare_password(params[:password])
        @current_user.email = params[:email]
        @current_user.save
      end
    end
  end
end
