require 'grape'
require 'http_helpers'
#require 'mongoid_user'

# top comment
module Api
  # top comment
  class User < Grape::API
    default_error_status 400

    helpers HttpHelpers

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

    desc 'POST	/users	users#create	create a new user'
    post '/users' do
      user = Mongodb::User.extendet_new(
        email: params[:email],
        pw: params[:password],
        token: params[:token]
      )
      user.save ? { password: '', email: user.email } : error!('erroring')
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
