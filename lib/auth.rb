# top comment
module Auth
  # top comment
  class << self
    # This is copied from Devise.secure_compare
    # def secure_compare2(a, b)
    #   return false if a.blank? || b.blank? || a.bytesize != b.bytesize
    #   l = a.unpack "C#{a.bytesize}"

    #   res = 0
    #   b.each_byte { |byte| res |= byte ^ l.shift }
    #   res == 0
    # end

    # from device
    def secure_compare(a, b)
      !blank?(a, b) && compare_bytes(a, b)
    end

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

    # from device
    def blank?(a, b)
      blank_string?(a) || blank_string?(b)
    end

    # from active_support
    def blank_string?(string_to_check)
      /\A[[:space:]]*\z/ === string_to_check
    end

    # from device
    def compare_bytes(a, b)
      a_bytesize = a.bytesize
      return false if a_bytesize != b.bytesize
      l = a.unpack "C#{a_bytesize}"
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end
  end
end
