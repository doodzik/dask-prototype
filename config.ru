$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'grape'

# setup mongoid

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

Mongoid.load!("./config/mongoid.yml")

# setup api
require 'application'

run Api::Main
