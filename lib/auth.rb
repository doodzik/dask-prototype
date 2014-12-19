# top comment
module Auth
  # top comment
  class << self
    def generate_unique_token
      loop do
        token = generate_token
        break token unless yield(token)
      end
    end

    def generate_unique_user_token
      generate_unique_token do |token|
        Mongodb::User.find_by token: token
      end
    end

    private

    def generate_token
      SecureRandom.urlsafe_base64(nil, false)
    end
  end
end
