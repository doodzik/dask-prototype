$LOAD_PATH.unshift(File.join("#{File.dirname(__FILE__)}/..", 'lib'))

require 'rspec'
require 'simplecov'

SimpleCov.start do
  add_group 'Models', '\w*_mongoid'
  add_group 'Api', '\w*_api'
  add_group 'Service', '(?!_api|_mongoid)'
  # add_group "Long files" do |src_file|
  #  src_file.lines.count > 100
  # add_group "Short files", LineFilter.new(5)
  # Using the LineFilter class defined in Filters section above
end

SimpleCov.minimum_coverage 99
SimpleCov.refuse_coverage_drop

RSpec.configure do |config|
  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end
