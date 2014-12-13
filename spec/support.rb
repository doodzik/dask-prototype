$LOAD_PATH.unshift(File.join("#{File.dirname(__FILE__)}/..", 'lib'))

=begin
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'spec'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
=end

require 'rspec'

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
