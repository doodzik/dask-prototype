require 'user_mongoid'
require 'grape/validations'

module Api
  # helper methods for grape
  module Helpers
    def authenticate!(token)
      current_user = Mongodb::User.current(token)
      current_user.authenticated?(token) ? current_user : false
    end
  end

  # grape param validator which checks if param.length is within a range
  class Within < Grape::Validations::SingleOptionValidator
    def validate_param!(attr_name, params)
      return true if @option.member?(params[attr_name].length)
      fail Grape::Exceptions::Validation,
           params: [@scope.full_name(attr_name)],
           message: "must be at the most #{@option} characters long"
    end
  end
end
