$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'grape'
require 'rack/cors'
require 'main' # require api

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

Mongoid.load!('./config/mongoid.yml')

# add cors support
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end


run Main::Api
