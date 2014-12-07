require 'Mongoid'
require 'lib/session'
require 'BCrypt'

# top comment
module Mongodb
  # top comment
  class User
    include Mongoid::Document
    include BCrypt
    include Session

    validates :email, presence: true
    validates_uniqueness_of :email, case_sensitive: false

    field :password_hash
    field :token
    field :email

    has_many :tasks

    def self.extendet_new(email:, pw:, token:)
      usr = new email: email
      usr.password = pw
      token = generate_unique_token { find_by token: token }
    end

    def self.current(token)
      find(token: token) || NullUser.new
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
      secure_compare givenToken, token
    end

    def to_bearer
      { access_token: token, token_type: 'bearer' }
    end
  end

  # top comment
  class NullUser
    def authenticated?(_token)
      false
    end
  end
end
