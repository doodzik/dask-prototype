# top comment
module Session
  # top comment
  class << self
    # This is copied from Devise.secure_compare
    def secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    def generate_unique_token
      loop do
        token = generate_token
        break token unless yield(token)
      end
    end

    private

    def generate_token
      SecureRandom.urlsafe_base64(nil, false)
    end
  end
end
