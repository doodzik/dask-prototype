$LOAD_PATH.unshift(File.join("#{File.dirname(__FILE__)}/..", 'app'))
require 'support'
require 'mongoid'
require 'mongoid-rspec'

# top comment
module Mongoid
  # top comment
  module Document
    def as_json(options = {})
      attrs = super(options)
      attrs['id'] = attrs['_id'].to_s
      attrs
    end
  end
end

#Mongoid.load!("#{ENV['BASEDIR']}/contracts/mongoid.yml")


RSpec.configure do |config|
  config.include Mongoid::Matchers#, type: :model
end
