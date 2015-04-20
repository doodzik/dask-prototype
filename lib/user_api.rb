require 'grape'
require 'helpers_api'
require 'user_mongoid'

module Api
  # top comment
  class User < Grape::API
    default_error_status 400
    format :json
    helpers Helpers

    params do
      requires :email, regexp: /.+@.+/
      requires :password, within: 6..32
    end
    desc 'POST /users users#create create a new user'
    post '/users' do
      user = Mongodb::User.extended_new(
        email: params[:email],
        pw: params[:password]
      )
      user.save ? { email: user.email } : error!('check your data')
    end

    before do
      @current_user = authenticate!(headers['Authentication'])
      error!('401 Unauthorized', 401) unless @current_user
    end

    desc 'GET /user users#show display a specific user'
    get '/user' do
      { email: @current_user.email }
    end

    params do
      requires :email,            regexp: /.+@.+/
      requires :password_confirm, within: 6..130
    end
    desc 'PATCH/PUT /users/:id users#update update a specific user'
    put '/users' do
      if @current_user.compare_password(params[:password_confirm])
        # TODO: password patch
        if (6..130).include?(params[:password].length)
          @current_user.password = params[:password]
        end
        if @current_user.email != params[:email]
          @current_user.email = params[:email]
        end
        if @current_user.valid?
          @current_user.save
        else
          error!({ passwordConfirm: 'email is already taken' }, 400)
        end
      else
        error!({ passwordConfirm: 'password doesn\'t match' }, 400)
      end
    end
  end
end
