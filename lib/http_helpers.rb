require 'mongoid_user'

# help methods for grape api
module HttpHelpers
  def authenticate!(token)
    current_user = Mongodb::User.current(token)
    current_user.authenticated?(token) ? current_user : false
  end
end
