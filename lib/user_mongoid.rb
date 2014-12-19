require 'mongoid'
require 'auth'
require 'bcrypt'
require 'task_mongoid'

# top comment
module Mongodb
  # top comment
  class User
    include Mongoid::Document
    include BCrypt

    validates :email, presence: true
    validates_uniqueness_of :email, case_sensitive: false

    field :password_hash
    field :token
    field :email

    embeds_many :tasks

    # TODO: put this into initializer
    def self.extendet_new(email:, pw:)
      usr = new email: email
      usr.password = pw
      usr.token = Auth.generate_unique_user_token
      usr
    end

    def self.current(token)
      find_by(token: token) || NullUser.new
    end

    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      self.password_hash = @password = Password.create(new_password)
    end

    def compare_password(password_to_compare)
      password == password_to_compare
    end

    def authenticated?(given_token)
      Auth.secure_compare given_token, token
    end

    def self.login(email, password)
      user = find_by(email: email)
      if user.compare_password(password)
        user.token = Auth.generate_unique_user_token
        user
      else
        NullUser.new
      end
    end

    def to_bearer
      { access_token: token, token_type: 'bearer' }
    end

    def to_json
      "{\"user\":#{as_json}}"
    end
  end

  # top comment
  class NullUser
    def method_missing(_name)
      false
    end
  end
end
