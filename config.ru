$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'config'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'mongoid'
require 'grape'
require 'rack/cors'
require 'main' # require api
require 'rack/contrib'

module Mongoid
  # reopens Document
  module Document
    # if document is converted into a json the id is converted to a string
    #   so that the client can use it.
    #   the id field specificly selected for ember-data
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

use Rack::TryStatic,
  :root => File.expand_path('../public', __FILE__),
  :urls => %w[/], :try => ['.html', 'index.html', '/index.html']

run Main::API
