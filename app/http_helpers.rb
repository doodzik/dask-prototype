require 'mongoid_user'

module HttpHelpers
  def authenticate!(token)
    current_user = Mongodb::User.current(token)
    current_user.authenticated?(token) ? current_user : false
  end
end
