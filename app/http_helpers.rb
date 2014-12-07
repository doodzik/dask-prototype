require 'mongoid_user'

# top comment
module HttpHelpers
  def current_user
    @current_user ||= Mongodb::User.current(headers[:authentication])
  end

  def authenticate!
    error!('401 Unauthorized', 401) unless current_user.authenticated?
  end
end
