# require 'active_support'

# This is copied from Devise.secure_compare
# def secure_compare2(a, b)
#   return false if a.blank? || b.blank? || a.bytesize != b.bytesize
#   l = a.unpack "C#{a.bytesize}"

#   res = 0
#   b.each_byte { |byte| res |= byte ^ l.shift }
#   res == 0
# end

# extends String class with stricter compare methods for auth
class String
  def blank?
    /\A[[:space:]]*\z/ === self
  end

  def present?
    !(blank?)
  end

  def strict_eql?(string)
    present? && string.present? && equal_by_bytes?(string)
  end

  def equal_bytesize?(string)
    bytesize == string.bytesize
  end

  def equal_by_bytes?(string)
    return false unless equal_bytesize?(string)
    unpacked = unpack "C#{bytesize}"
    res = 0
    string.each_byte { |byte| res |= byte ^ unpacked.shift }
    res == 0
  end
end
