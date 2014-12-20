# extends String class with stricter compare methods for auth
class String
  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true
  #
  # @return [true, false]
  def blank?
    /\A[[:space:]]*\z/ === self
  end

  # calls not on blank?
  # @return [true, false]
  def present?
    !(blank?)
  end

  # checks if a string is really really equal to another
  # @return [true, false]
  def strict_eql?(string)
    present? && string.present? && equal_by_bytes?(string)
  end

  # checks if bytesize is of two strings are equal
  # @return [true, false]
  def equal_bytesize?(string)
    bytesize == string.bytesize
  end

  # @todo add explainaition
  # @return [true, false]
  def equal_by_bytes?(string)
    return false unless equal_bytesize?(string)
    unpacked = unpack "C#{bytesize}"
    res = 0
    string.each_byte { |byte| res |= byte ^ unpacked.shift }
    res == 0
  end
end
