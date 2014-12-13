require 'mongoid'
require 'session'
require 'bcrypt'
require 'mongoid_task'

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

    # TODO put this into initializer
    def self.extendet_new(email:, pw:, token:)
      usr = new email: email
      usr.password = pw
      usr.token = generate_token
      usr
    end

    def self.current(token)
      find_by(token: token) || NullUser.new
    end

    def password
      @password ||= Password.new(password_hash)
    end

    def password=(new_password)
      @password = Password.create(new_password)
      self.password_hash = @password
    end

    def compare_password(password_to_compare)
      password == password_to_compare
    end

    def authenticated?(givenToken)
      Session.secure_compare givenToken, token
    end

    def self.login(email, password)
      user = find_by(email: email)
      if user.compare_password(password)
        user.token = generate_token
        user
      else
        NullUser.new
      end
    end

    def self.generate_token
      Session.generate_unique_token do |token|
        Mongodb::User.find_by token: token
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
