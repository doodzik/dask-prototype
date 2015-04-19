require 'mongoid'
require 'auth'
require 'bcrypt'
require 'task_mongoid'
require 'string'

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

    # extended_new assigns a unique token to self.token
    #   and assigns password
    # @param email [String]
    # @param pw [String] plain password
    # @return [User::Model]
    def self.extended_new(email:, pw:)
      usr = new email: email
      usr.password = pw
      usr.token = Auth.generate_unique_user_token
      usr
    end

    # finds a User by token
    # @param token [String]
    # @return [User::Model|User::NullModel]
    def self.current(token)
      find_by(token: token) || NullUser.new
    end

    # retrieves password from hash and
    #   assigns it to @password if not already set
    def password
      @password ||= Password.new(password_hash)
    end

    # pass a plaintext password which is decipherd and stored
    #   in self.password_hash and @password
    # @param new_password [String] plain password
    def password=(new_password)
      self.password_hash = @password = Password.create(new_password)
    end

    # compares given password with the password in the Database
    # @param password_to_compare [String] plain password
    def compare_password(password_to_compare)
      password == password_to_compare
    end

    # check if user is authenticated.
    # By comparing provided given token with instance token.
    # @param given_token [String]
    def authenticated?(given_token)
      token.strict_eql? given_token
    end

    # retrieves user by email and password and generate new token.
    # @param email [String]
    # @param password [String]
    # @return [User::Model|User::NullModel]
    # @todo refactor to Auth when splitting modules
    def self.login(email, password)
      user = find_by(email: email)
      if user && user.compare_password(password)
        user.token = Auth.generate_unique_user_token
        user
      else
        NullUser.new
      end
    end

    # converts instance into bearer hash
    def to_bearer
      { access_token: token, token_type: 'bearer' }
    end

    # converts instance into json
    #   which is pluggable to ember data
    def to_json
      "{\"user\":#{as_json}}"
    end
  end

  # returns for each method call false
  class NullUser
    def method_missing(_name, arg)
      false
    end
  end
end
