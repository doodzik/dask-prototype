module Auth
  # Singelton class
  class << self
    # generates tokens until yield returns false
    #   then it returns the given token
    # @yields [String] token proposal
    # @return [String] token
    def generate_unique_token
      loop do
        token = generate_token
        break token unless yield(token)
      end
    end

    # returns unique token for a user
    # @return [String] token
    def generate_unique_user_token
      generate_unique_token do |token|
        Mongodb::User.find_by token: token
      end
    end

    private

    # generates random string
    # @return [String]
    def generate_token
      SecureRandom.urlsafe_base64(nil, false)
    end
  end
end
